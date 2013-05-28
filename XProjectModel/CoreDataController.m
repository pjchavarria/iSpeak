//
//  SDCoreDataController.m
//  SignificantDates
//
//  Created by Chris Wagner on 5/14/12.
//

#import "CoreDataController.h"


NSString * const kPalabraAvanceClass = @"PalabraAvance";
NSString * const kCursoAvanceClass = @"CursoAvance";
NSString * const kOracionClass = @"Oracion";
NSString * const kCursoClass = @"Curso";
NSString * const kPalabraClass = @"Palabra";
NSString * const kUsuarioClass = @"Usuario";

@interface CoreDataController ()

@property (strong, nonatomic) NSManagedObjectContext *masterManagedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation CoreDataController

enum {
    kSincronizacionEstadoInsertado,
    kSincronizacionEstadoModificado,
    kSincronizacionEstadoEliminado,
    kSincronizacionEstadoSincronizado
}SincronizacionEstado;

@synthesize masterManagedObjectContext = _masterManagedObjectContext;
@synthesize backgroundManagedObjectContext = _backgroundManagedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id)sharedInstance {
    static dispatch_once_t once;
    static CoreDataController *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)setUsuarioActivo:(Usuario *)usuarioActivo
{
	
	if (!usuarioActivo) {
		[[NSUserDefaults standardUserDefaults] setObject:@"ninguno" forKey:@"usuarioActivo"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}else {
		[[NSUserDefaults standardUserDefaults] setObject:usuarioActivo.objectId forKey:@"usuarioActivo"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	_usuarioActivo = usuarioActivo;
}

#pragma mark - Core Data stack

// Used to propegate saves to the persistent store (disk) without blocking the UI
- (NSManagedObjectContext *)masterManagedObjectContext {
    if (_masterManagedObjectContext != nil) {
        return _masterManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _masterManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_masterManagedObjectContext performBlockAndWait:^{
            [_masterManagedObjectContext setPersistentStoreCoordinator:coordinator];
        }];
        
    }
    return _masterManagedObjectContext;
}

// Return the NSManagedObjectContext to be used in the background during sync
- (NSManagedObjectContext *)backgroundManagedObjectContext {
    if (_backgroundManagedObjectContext != nil) {
        return _backgroundManagedObjectContext;
    }
    
    NSManagedObjectContext *masterContext = [self masterManagedObjectContext];
    if (masterContext != nil) {
        _backgroundManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_backgroundManagedObjectContext performBlockAndWait:^{
            [_backgroundManagedObjectContext setParentContext:masterContext]; 
        }];
    }
    
    return _backgroundManagedObjectContext;
}

// Return the NSManagedObjectContext to be used in the background during sync
- (NSManagedObjectContext *)newManagedObjectContext {
    NSManagedObjectContext *newContext = nil;
    NSManagedObjectContext *masterContext = [self masterManagedObjectContext];
    if (masterContext != nil) {
        newContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [newContext performBlockAndWait:^{
            [newContext setParentContext:masterContext]; 
        }];
    }
    
    return newContext;
}

- (void)saveMasterContext {
    [self.masterManagedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.masterManagedObjectContext save:&error];
        if (!saved) {
            // do some real error handling 
            NSLog(@"Could not save master context due to %@", error);
        }
    }];
}

- (void)saveBackgroundContext {
    [self.backgroundManagedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.backgroundManagedObjectContext save:&error];
        if (!saved) {
            // do some real error handling 
            NSLog(@"Could not save background context due to %@", error);
        }
    }];
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"XProjectModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"XProjectModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Insert Core Data

- (void)insertUsuario:(UsuarioDTO *)data
{
	Usuario *usuario = [NSEntityDescription insertNewObjectForEntityForName:kUsuarioClass inManagedObjectContext:self.backgroundManagedObjectContext];
	
	usuario.username = data.username;
	usuario.password = data.password;
	usuario.objectId = data.objectId;
}
- (void)updateUsuario:(UsuarioDTO *)data
{
	Usuario *usuario = [self getObjectForClass:kUsuarioClass predicate:[NSPredicate predicateWithFormat:@"objectId like %@",data.objectId]];

	usuario.username = data.username;
	usuario.password = data.password;
	usuario.objectId = data.objectId;
}


- (void)insertCurso:(CursoDTO*)data
{
	Curso *curso = [NSEntityDescription insertNewObjectForEntityForName:kCursoClass inManagedObjectContext:self.backgroundManagedObjectContext];
	CursoDTO *cursoDTO = data;
	
	curso.cantidadPalabras = cursoDTO.cantidadPalabras;
	curso.curso = cursoDTO.curso;
	curso.nombre = cursoDTO.nombre;
	curso.objectId = cursoDTO.objectId;
}
- (void)insertOracion:(OracionDTO*)data
{
	Oracion *oracion = [NSEntityDescription insertNewObjectForEntityForName:kOracionClass inManagedObjectContext:self.backgroundManagedObjectContext];
	OracionDTO *oracionDTO = data;
	
	oracion.objectId = oracionDTO.objectId;
	oracion.audio = oracionDTO.audio;
	oracion.oracion = oracionDTO.oracion;
	oracion.traduccion = oracionDTO.traduccion;
	
	// Relaciones
	oracion.palabra = [self getObjectForClass:kPalabraClass predicate:[NSPredicate predicateWithFormat:@"objectId like %@",oracionDTO.palabra]];
}
- (void)insertPalabra:(PalabraDTO*)data
{
	Palabra *palabra = [NSEntityDescription insertNewObjectForEntityForName:kPalabraClass inManagedObjectContext:self.backgroundManagedObjectContext];
	PalabraDTO *palabraDTO = data;
	
	palabra.audio = palabraDTO.audio;
	palabra.objectId = palabraDTO.objectId;
	palabra.palabra = palabraDTO.palabra;
	palabra.tipoPalabra = palabraDTO.tipoPalabra;
	palabra.traduccion = palabraDTO.traduccion;
    
    palabra.curso = [self getObjectForClass:kCursoClass predicate:[NSPredicate predicateWithFormat:@"objectId like %@",palabraDTO.curso]];
}
- (void)insertPalabraAvance:(PalabraAvanceDTO*)data
{
	PalabraAvance *palabraAvance = [NSEntityDescription insertNewObjectForEntityForName:kPalabraAvanceClass inManagedObjectContext:self.backgroundManagedObjectContext];
	PalabraAvanceDTO *palabraAvanceDTO = data;
	
	palabraAvance.objectId = palabraAvanceDTO.objectId;
	palabraAvance.avance = palabraAvanceDTO.avance;
	palabraAvance.estado = palabraAvanceDTO.estado;
	palabraAvance.prioridad = palabraAvanceDTO.prioridad;
	palabraAvance.sincronizado = palabraAvanceDTO.sincronizado;
	palabraAvance.ultimaFechaRepaso = palabraAvanceDTO.ultimaFechaRepaso;
	palabraAvance.ultimaSincronizacion = palabraAvanceDTO.ultimaSincronizacion;
	
	// Relaciones
	palabraAvance.usuario = self.usuarioActivo;
	palabraAvance.palabra = [self getObjectForClass:kPalabraClass predicate:[NSPredicate predicateWithFormat:@"objectId like %@",palabraAvanceDTO.palabra]];
}
- (void)insertCursoAvance:(CursoAvanceDTO*)data
{
	CursoAvance *cursoAvance = [NSEntityDescription insertNewObjectForEntityForName:kCursoAvanceClass inManagedObjectContext:self.backgroundManagedObjectContext];
	CursoAvanceDTO *cursoAvanceDTO = data;
	
	cursoAvance.objectId = cursoAvanceDTO.objectId;
	cursoAvance.avance = cursoAvanceDTO.avance;
	cursoAvance.palabrasComenzadas = cursoAvanceDTO.palabrasComenzadas;
	cursoAvance.palabrasCompletas = cursoAvanceDTO.palabrasCompletas;
	cursoAvance.sincronizado = cursoAvanceDTO.sincronizado;
	cursoAvance.tiempoEstudiado = cursoAvanceDTO.tiempoEstudiado;
	cursoAvance.ultimaSincronizacion = cursoAvanceDTO.ultimaSincronizacion;
	
	// Relaciones
	cursoAvance.usuario = self.usuarioActivo;
	cursoAvance.curso = [self getObjectForClass:kCursoClass predicate:[NSPredicate predicateWithFormat:@"objectId like %@",cursoAvanceDTO.curso]];
}

#pragma mark - Update Core Data

- (void)updateCurso:(CursoDTO*)data
{
    
}
- (void)updateOracion:(OracionDTO*)data
{
	
}
- (void)updatePalabra:(PalabraDTO*)data
{
	
}
- (void)updatePalabraAvance:(PalabraAvanceDTO*)data
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kPalabraAvanceClass];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId like %@",data.objectId];
    [fetchRequest setPredicate:predicate];
	[fetchRequest setFetchLimit:1];
    NSError *error = nil;
    NSArray *results = [self.backgroundManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(results.count > 0)
    {
        PalabraAvance *palabraAvance = [results objectAtIndex:0];
        palabraAvance.avance = data.avance;
        palabraAvance.estado = data.estado;
        palabraAvance.prioridad = data.prioridad;
        palabraAvance.sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoSincronizado];
        palabraAvance.ultimaFechaRepaso = data.ultimaFechaRepaso;
        palabraAvance.ultimaSincronizacion = [NSDate date];
        
        [self saveBackgroundContext];
    }
}
- (void)updateCursoAvance:(CursoAvanceDTO*)data
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kCursoAvanceClass];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId like %@",data.objectId];
    [fetchRequest setPredicate:predicate];
	[fetchRequest setFetchLimit:1];
    NSError *error = nil;
    NSArray *results = [self.backgroundManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if(results.count > 0)
    {
        CursoAvance *cursoAvance = [results objectAtIndex:0];
        cursoAvance.avance = data.avance;
        cursoAvance.palabrasComenzadas = data.palabrasComenzadas;
        cursoAvance.palabrasCompletas = data.palabrasCompletas;
        cursoAvance.sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoSincronizado];
        cursoAvance.tiempoEstudiado = data.tiempoEstudiado;
        cursoAvance.ultimaSincronizacion = [NSDate date];
        
        [self saveBackgroundContext];
    }
}


#pragma mark - Core Data Utility Methods

- (id)getObjectForClass:(NSString *)className predicate:(NSPredicate *)predicate
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    [fetchRequest setPredicate:predicate];
	[fetchRequest setFetchLimit:1];
	NSError *error = nil;
	NSArray *results = [self.backgroundManagedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
		NSLog(@"%@",error);
	}
	
	if (!results.count) {
		return nil;
	}else{
		return results[0];
	}
	
}

- (NSArray *)managedObjectsForClass:(NSString *)className {
	
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = self.backgroundManagedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
//    NSPredicate *predicate;
//    if (inIds) {
//        predicate = [NSPredicate predicateWithFormat:@"objectId IN %@", idArray];
//    } else {
//        predicate = [NSPredicate predicateWithFormat:@"NOT (objectId IN %@)", idArray];
//    }
//    
//    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:
                                      [NSSortDescriptor sortDescriptorWithKey:@"objectId" ascending:YES]]];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return results;
}
- (NSArray *)managedObjectsForClass:(NSString *)className predicate:(NSPredicate *)predicate
{
	__block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = self.backgroundManagedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
	[fetchRequest setPredicate:predicate];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return results;
}
- (NSArray *)managedObjectsForClass:(NSString *)className sortKey:(NSString *)sortKey ascending:(BOOL)ascending
{
	
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = self.backgroundManagedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];

    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:
                                      [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:ascending]]];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return results;
}

@end
