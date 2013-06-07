//
//  SyncEngine.m
//  iSpeak
//
//  Created by Paul on 16/05/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import "SyncEngine.h"
#import "CoreDataController.h"
#import "DTO.h"

@implementation SyncEngine

enum {
    kSincronizacionEstadoInsertado,
    kSincronizacionEstadoModificado,
    kSincronizacionEstadoEliminado,
    kSincronizacionEstadoSincronizado
}SincronizacionEstado;

+ (SyncEngine *)sharedEngine {
    static SyncEngine *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[SyncEngine alloc] init];
    });
    
    return sharedEngine;
}
#pragma mark - Sync Create ?
- (CursoAvanceDTO *)createCursoAvance:(Usuario *)usuario curso:(Curso *)curso
{
	CursoAvanceDTO *cursoAvance = [CursoAvanceDTO object];
    cursoAvance.usuario = usuario.objectId;
    cursoAvance.avance = [NSNumber numberWithInt:0];
    cursoAvance.palabrasComenzadas = [NSNumber numberWithInt:0];
    cursoAvance.palabrasCompletas = [NSNumber numberWithInt:0];
    cursoAvance.tiempoEstudiado = [NSNumber numberWithInt:0];
    cursoAvance.ultimaSincronizacion = [NSDate date];
    cursoAvance.sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoSincronizado];
    cursoAvance.curso = curso.objectId;
	
	return cursoAvance;
}
- (PalabraAvanceDTO *)createPalabraAvance:(Usuario *)usuario palabra:(Palabra *)palabra
{
	PalabraAvanceDTO *palabraAvance = [PalabraAvanceDTO object];
    palabraAvance.usuario = usuario.objectId;
    palabraAvance.avance = [NSNumber numberWithInt:0];
    palabraAvance.estado = [NSNumber numberWithInt:0];
    palabraAvance.prioridad = [NSNumber numberWithInt:0];
    palabraAvance.ultimaFechaRepaso = [NSDate date];
    palabraAvance.ultimaSincronizacion = [NSDate date];
    palabraAvance.sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoSincronizado];
    palabraAvance.palabra = palabra.objectId;
	
	return palabraAvance;
}

#pragma mark - SyncEngine Dirty Job

- (void)masterSubordinateSyncForClass:(NSString *)class columnName:(NSString *)key objectId:(NSString *)objectId block:(void(^)())handler
{
	CoreDataController *coreDataController = [CoreDataController sharedInstance];
	NSArray *storedRecords = [coreDataController managedObjectsForClass:class];
	NSLog(@"Stored %@: %@",class,storedRecords);
	
	PFQuery *query = [PFQuery queryWithClassName:class];
	if (key && objectId) {
		[query whereKey:key equalTo:[PFObject objectWithoutDataWithClassName:kCursoClass objectId:objectId]];
	}
    [query findObjectsInBackgroundWithBlock:^(NSArray *fetchedObjects, NSError *error) {
		if (error) {
			NSLog(@"%@",error);
			handler();
		}
        NSLog(@"Parse %@: %@",class,fetchedObjects);
		NSMutableArray *fetchedObjectsLeftToSync = fetchedObjects.mutableCopy;
        NSMutableArray *fetchedObjectsIDs = [[NSMutableArray alloc] init];
        for (PFObject *object in fetchedObjects){
            [fetchedObjectsIDs addObject:object.objectId];
        }
		
		for (int i=0;i<fetchedObjects.count;i++) {
			NSManagedObject *storedManagedObject = (storedRecords.count > i)?storedManagedObject = storedRecords[i] : nil;
			
			// UPDATE
			// si encuentra un id jalado de parse q es igual al guardado en storedRecords[currentIndex]
			if ([fetchedObjectsIDs containsObject:[storedManagedObject valueForKey:@"objectId"]]) {
				NSString *idObject = [storedManagedObject valueForKey:@"objectId"];
				id foundObject = [fetchedObjects objectAtIndex:[fetchedObjectsIDs indexOfObject:idObject]];
				
				if ([foundObject isKindOfClass:[CursoDTO class]]) {
					[coreDataController updateCurso:storedRecords[i] withData:foundObject];
				}else if([foundObject isKindOfClass:[PalabraDTO class]]){
					[coreDataController updatePalabra:storedRecords[i] withData:foundObject];
				}else if([foundObject isKindOfClass:[OracionDTO class]]){
					[coreDataController updateOracion:storedRecords[i] withData:foundObject];
				}
								
				[fetchedObjectsLeftToSync removeObject:foundObject];
			
			// CREATE
			}else if(!storedManagedObject){
				id foundObject = fetchedObjectsLeftToSync.lastObject;
				
				if ([foundObject isKindOfClass:[CursoDTO class]]) {
					[coreDataController insertCurso:foundObject];
				}else if([foundObject isKindOfClass:[PalabraDTO class]]){
					[coreDataController insertPalabra:foundObject];
				}else if([foundObject isKindOfClass:[OracionDTO class]]){
					[coreDataController insertOracion:foundObject];
				}
				
				[fetchedObjectsLeftToSync removeLastObject];
			}
			
		}
		[coreDataController saveBackgroundContext];
		[coreDataController saveMasterContext];
		NSArray *toredRecords = [coreDataController managedObjectsForClass:class];
		NSLog(@"Result %@: %@",class,toredRecords);
		handler();
    }];
}
- (void)masterMasterSyncForClass:(NSString *)class
{
	
}

#pragma mark - Sync Classes Methods
- (void)syncUser:(UsuarioDTO*)data
{
	CoreDataController *coreDataController = [CoreDataController sharedInstance];
	Usuario * usuario = [coreDataController getObjectForClass:kUsuarioClass predicate:[NSPredicate predicateWithFormat:@"objectId like %@",data.objectId]];
	if (!usuario) {
		[coreDataController insertUsuario:data];
		[coreDataController saveBackgroundContext];
	}else {
		// update existing user data if needed
	}
	usuario = [coreDataController getObjectForClass:kUsuarioClass predicate:[NSPredicate predicateWithFormat:@"objectId like %@",data.objectId]];
	coreDataController.usuarioActivo = usuario;
}
- (void)syncCursoAvance:(NSArray *)storedRecords
{
	
		
    for(CursoAvance *cursoAvance in storedRecords)
    {
        CursoAvanceDTO *cursoAvanceDTO = [CursoAvanceDTO object];
        cursoAvanceDTO.avance = cursoAvance.avance;
        cursoAvanceDTO.palabrasComenzadas = cursoAvance.palabrasComenzadas;
        cursoAvanceDTO.curso = cursoAvance.curso.objectId;
        cursoAvanceDTO.palabrasCompletas = cursoAvance.palabrasCompletas;
        cursoAvanceDTO.tiempoEstudiado = cursoAvance.tiempoEstudiado;
        cursoAvanceDTO.ultimaSincronizacion = [NSDate date];
        cursoAvanceDTO.usuario = cursoAvance.usuario.objectId;
        cursoAvanceDTO.sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoSincronizado];
		
		[cursoAvanceDTO saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			if (succeeded) {
				[[CoreDataController sharedInstance] updateCursoAvance:cursoAvance withData:cursoAvanceDTO];
			}
		}];
		
    }
}


- (void)syncCursoAvanceConUsuario:(Usuario *)usuario curso:(Curso *)curso completion:(void(^)())handler
{
	CoreDataController *coreDataController = [CoreDataController sharedInstance];
	
	NSArray *storedRecords = [coreDataController managedObjectsForClass:kCursoAvanceClass];
	NSLog(@"Stored kCursoAvanceClass: %@",storedRecords);
	handler();

}

- (void)syncCursoAvanceConUsuario:(Usuario *)usuario completion:(void(^)())handler
{
	CoreDataController *coreDataController = [CoreDataController sharedInstance];
	
	NSArray *storedRecords = [coreDataController managedObjectsForClass:kCursoAvanceClass];
	NSLog(@"Stored kCursoAvanceClass: %@",storedRecords);
	handler();

}

- (void)syncPalabraAvance:(NSArray *)storedRecords
{
    for(PalabraAvance *palabraAvance in storedRecords)
    {
        PalabraAvanceDTO *palabraAvanceDTO = [PalabraAvanceDTO object];
        palabraAvanceDTO.avance = palabraAvance.avance;
        palabraAvanceDTO.estado = palabraAvance.estado;
        palabraAvanceDTO.palabra = palabraAvance.palabra.objectId;
        palabraAvanceDTO.prioridad = palabraAvance.prioridad;
        palabraAvanceDTO.ultimaFechaRepaso = palabraAvance.ultimaFechaRepaso;
        palabraAvanceDTO.ultimaSincronizacion = [NSDate date];
        palabraAvanceDTO.usuario = palabraAvance.usuario.objectId;
        palabraAvanceDTO.sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoSincronizado];
		
		[palabraAvanceDTO saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			if (succeeded) {
				[[CoreDataController sharedInstance] updatePalabraAvance:palabraAvance withData:palabraAvanceDTO];
			}
		}];
        
    }
}
- (void)syncPalabraAvanceConUsuario:(Usuario *)usuario palabra:(Palabra*)palabra completion:(void(^)())handler
{
	CoreDataController *coreDataController = [CoreDataController sharedInstance];
	
	NSArray *storedRecords = [coreDataController managedObjectsForClass:kPalabraClass];
	NSLog(@"Stored kPalabraClass: %@",storedRecords);
	

}


#pragma mark - SyncEngine Scenario Methods

- (void)seAcabaDeLoguear:(Usuario *)usuario completion:(void(^)())handler
{
	// Descargar/Actualizar todos los cursos
	// Descargar/Actualizar todos los avances de cursos
	[self masterSubordinateSyncForClass:kCursoClass columnName:nil objectId:nil block:^{
		
		[self syncCursoAvanceConUsuario:usuario completion:^{
			
			handler();
			
		}];
	}];
	
	
}
- (void)iniciarCurso:(Curso *)curso completion:(void(^)())handler
{
	// Descargar palabras y oraciones del curso
	// Insertar avances de palabras y avances del curso
	[self masterSubordinateSyncForClass:kPalabraClass
							 columnName:@"curso"
							   objectId:curso.objectId
								  block:^{
		
		[self masterSubordinateSyncForClass:kOracionClass
								 columnName:@"curso"
								   objectId:curso.objectId
									  block:
		 ^{
			 // Creando curso/palabra avance
			  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"curso.objectId like %@",curso.objectId];
			  NSArray *storedPalabras = [[CoreDataController sharedInstance] managedObjectsForClass:kPalabraClass predicate:predicate];
			  Usuario *usuario = [[CoreDataController sharedInstance] usuarioActivo];
			  __block NSMutableArray *dataToSave = [NSMutableArray array];
			 [dataToSave addObject:[self createCursoAvance:usuario curso:curso]];
			  for (Palabra *palabra in storedPalabras) {
				  [dataToSave addObject:[self createPalabraAvance:usuario palabra:palabra]];
			  }
			  [PFObject saveAllInBackground:dataToSave block:
			   ^(BOOL succeeded, NSError *error){
				  if (succeeded) {
					  for (id object in dataToSave) {
						  ((CursoAvanceDTO*)object).sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoInsertado];
						  if ([object isKindOfClass:[CursoAvanceDTO class]]) {
							  [[CoreDataController sharedInstance] insertCursoAvance:object];
						  }else if ([object isKindOfClass:[PalabraAvanceDTO class]]){
							  [[CoreDataController sharedInstance] insertPalabraAvance:object];
						  }
						  
					  }
					  handler();
				  }
			  }];
		}];
		
    }];
}
- (void)iniciarRepaso:(Curso *)curso completion:(void(^)())handler
{
	// Descargar/Actualizar palabras y oraciones del curso
	// Actualizar avances de palabras

}
- (void)finalizarLeccion:(Curso *)curso completion:(void(^)())handler
{
	// Actualizar avance del curso y avance de las palabras del curso
//    [self syncCursoAvanceConUsuario:[[CoreDataController sharedInstance] usuarioActivo] Curso:curso completion:^{
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"curso.objectId like %@",curso.objectId];
//        NSArray *storedPalabras = [[CoreDataController sharedInstance] managedObjectsForClass:kPalabraClass predicate:predicate];
//        for(Palabra *palabra in storedPalabras){
//            [self syncPalabraAvanceConUsuario:[[CoreDataController sharedInstance] usuarioActivo] Palabra:palabra completion:^{
//                
//            }];
//        }
//    }];
}
- (void)elInternetRegresoCompletion:(void(^)())handler
{
	// Actualizar avance de todos los cursos y avance de todas las palabras NO SINCRONIZADAS
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sincronizado not like %@",kSincronizacionEstadoSincronizado];
    
    
    NSArray *storedPalabras = [[CoreDataController sharedInstance] managedObjectsForClass:kPalabraAvanceClass predicate:predicate];
    [self syncPalabraAvance:storedPalabras];
    
    
    NSArray *storedCursos = [[CoreDataController sharedInstance] managedObjectsForClass:kCursoAvanceClass predicate:predicate];
    [self syncCursoAvance:storedCursos];
}

#pragma mark - SyncEngine Utility Methods

- (NSDate *)mostRecentUpdatedAtDateForEntityWithName:(NSString *)entityName {
    __block NSDate *date = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [request setSortDescriptors:[NSArray arrayWithObject:
                                 [NSSortDescriptor sortDescriptorWithKey:@"ultimaSincronizacion" ascending:NO]]];
    [request setFetchLimit:1];
    [[[CoreDataController sharedInstance] backgroundManagedObjectContext] performBlockAndWait:^{
        NSError *error = nil;
        NSArray *results = [[[CoreDataController sharedInstance] backgroundManagedObjectContext] executeFetchRequest:request error:&error];
        if ([results lastObject])   {
            date = [[results lastObject] valueForKey:@"updatedAt"];
        }
    }];
    
    return date;
}
@end
