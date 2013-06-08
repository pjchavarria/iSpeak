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
    cursoAvance.usuarioId = usuario.objectId;
    cursoAvance.avance = [NSNumber numberWithInt:0];
    cursoAvance.palabrasComenzadas = [NSNumber numberWithInt:0];
    cursoAvance.palabrasCompletas = [NSNumber numberWithInt:0];
    cursoAvance.tiempoEstudiado = [NSNumber numberWithInt:0];
    cursoAvance.ultimaSincronizacion = [NSDate date];
    cursoAvance.sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoSincronizado];
    cursoAvance.cursoId = curso.objectId;
	cursoAvance.curso = [PFObject objectWithoutDataWithClassName:kCursoClass objectId:curso.objectId];
	return cursoAvance;
}
- (PalabraAvanceDTO *)createPalabraAvance:(Usuario *)usuario palabra:(Palabra *)palabra
{
	PalabraAvanceDTO *palabraAvance = [PalabraAvanceDTO object];
    palabraAvance.usuarioId = usuario.objectId;
    palabraAvance.avance = [NSNumber numberWithInt:0];
    palabraAvance.estado = [NSNumber numberWithInt:0];
    palabraAvance.prioridad = [NSNumber numberWithInt:0];
    palabraAvance.ultimaFechaRepaso = [NSDate date];
    palabraAvance.ultimaSincronizacion = [NSDate date];
    palabraAvance.sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoSincronizado];
    palabraAvance.palabraId = palabra.objectId;
	
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
    [query findObjectsInBackgroundWithBlock:^(NSArray *serverObjects, NSError *error) {
        
		if (error) {
			NSLog(@"%@",error);
			handler();
		}
        
        NSLog(@"Parse %@: %@",class,serverObjects);
		NSMutableArray *serverObjectsLeftToSync = serverObjects.mutableCopy;
        NSMutableArray *serverObjectsIDs = [[NSMutableArray alloc] init];
        for (PFObject *object in serverObjects){
            [serverObjectsIDs addObject:object.objectId];
        }
		
		for (int i=0;i<serverObjects.count;i++) {
			NSManagedObject *storedManagedObject = (storedRecords.count > i)?storedManagedObject = storedRecords[i] : nil;
			
			// UPDATE
			// si encuentra un id jalado de parse q es igual al guardado en storedRecords[currentIndex]
			if ([serverObjectsIDs containsObject:[storedManagedObject valueForKey:@"objectId"]]) {
				NSString *idObject = [storedManagedObject valueForKey:@"objectId"];
				id foundObject = [serverObjects objectAtIndex:[serverObjectsIDs indexOfObject:idObject]];
				
				if ([foundObject isKindOfClass:[CursoDTO class]]) {
					[coreDataController updateCurso:storedRecords[i] withData:foundObject];
				}else if([foundObject isKindOfClass:[PalabraDTO class]]){
					[coreDataController updatePalabra:storedRecords[i] withData:foundObject];
				}else if([foundObject isKindOfClass:[OracionDTO class]]){
					[coreDataController updateOracion:storedRecords[i] withData:foundObject];
				}
								
				[serverObjectsLeftToSync removeObject:foundObject];
			
			// CREATE
			}else if(!storedManagedObject){
				id foundObject = serverObjectsLeftToSync.lastObject;
				
				if ([foundObject isKindOfClass:[CursoDTO class]]) {
					[coreDataController insertCurso:foundObject];
				}else if([foundObject isKindOfClass:[PalabraDTO class]]){
                    PalabraDTO *palabraDTO = foundObject;
                    CursoDTO *cursoDTO = (CursoDTO *)[[palabraDTO objectForKey:@"curso"] fetchIfNeeded];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId like %@",cursoDTO.objectId];
                    Curso *curso = [coreDataController getObjectForClass:kCursoClass predicate:predicate];
                    
					[coreDataController insertPalabra:foundObject curso:curso];
				}else if([foundObject isKindOfClass:[OracionDTO class]]){
                    OracionDTO *oracionDTO = foundObject;
                    PalabraDTO *cursoDTO = (PalabraDTO *)[[oracionDTO objectForKey:@"palabra"] fetchIfNeeded];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId like %@",cursoDTO.objectId];
                    Palabra *palabra = [coreDataController getObjectForClass:kPalabraClass predicate:predicate];
                    
					[coreDataController insertOracion:foundObject palabra:palabra];
				}
				
				[serverObjectsLeftToSync removeLastObject];
			}
			
		}
		[coreDataController saveBackgroundContext];
		[coreDataController saveMasterContext];
		NSArray *toredRecords = [coreDataController managedObjectsForClass:class];
		NSLog(@"Result %@: %@",class,toredRecords);
		handler();
    }];
}
- (void)masterMasterSyncForClass:(NSString *)class columnName:(NSString *)key objectId:(NSString *)objectId block:(void(^)())handler
{
    // Ok so, this is the plan
    // 1. Download todos los objetos actualizados despues de la ultima fecha de sync
    // 2. Recorremos los objetos
    // 3. Si es nuevo insertar
    // 4. si no, si gana servidor -> actualizar (resolver conflictos, tomar mayor porcentaje)
    // 5. si no, si gana local -> pushear
    // 6. Despues de todo eso, -> pushear nuevos creados localmente
    
	CoreDataController *coreDataController = [CoreDataController sharedInstance];
	NSArray *storedRecords = [coreDataController managedObjectsForClass:class];
	NSLog(@"Stored %@: %@",class,storedRecords);
    
    NSDate *lastUpdatedDate = ((CursoAvanceDTO*)storedRecords.lastObject).updatedAt;

    // Obtener todos los objetos que hallan sido actualizados despues de la ultima fecha de actualizacion
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"updatedAt > %@",lastUpdatedDate];
    NSLog(@"%@",lastUpdatedDate);
    PFQuery *query = [PFQuery queryWithClassName:class predicate:predicate];
    
	if (key && objectId) {
        NSString *relationClassName;
        if ([class isEqualToString:kCursoAvanceClass]) {
            relationClassName = kCursoClass;
        }else if ([class isEqualToString:kPalabraAvanceClass]){
            relationClassName = kPalabraClass;
        }
		[query whereKey:key equalTo:[PFObject objectWithoutDataWithClassName:relationClassName objectId:objectId]];
        
	}
    [query findObjectsInBackgroundWithBlock:^(NSArray *serverObjects, NSError *error) {
		if (error) {
			NSLog(@"%@",error);
			handler();
		}
        NSLog(@"Parse %@: %@",class,serverObjects);
        NSMutableArray *objectsToPush = [[NSMutableArray alloc] init];
		NSMutableArray *serverObjectsLeftToSync = serverObjects.mutableCopy;
        NSMutableArray *serverObjectsIDs = [[NSMutableArray alloc] init];
        for (PFObject *object in serverObjects){
            [serverObjectsIDs addObject:object.objectId];
        }
		
		for (int i=0;i<serverObjects.count;i++) {
			NSManagedObject *storedManagedObject = (storedRecords.count > i)?storedManagedObject = storedRecords[i] : nil;
			
			// UPDATE
			// si encuentra un id jalado de parse q es igual al guardado en storedRecords[currentIndex]
			if ([serverObjectsIDs containsObject:[storedManagedObject valueForKey:@"objectId"]]) {
				NSString *idObject = [storedManagedObject valueForKey:@"objectId"];
				id foundObject = [serverObjects objectAtIndex:[serverObjectsIDs indexOfObject:idObject]];
				
                int avanceServidor = ((CursoAvance *)storedRecords[i]).avance.intValue;
                int avanceLocal = ((CursoAvanceDTO *)foundObject).avance.intValue;
                
                // SI GANA SERVIDOR, guardamos
                if (avanceServidor>=avanceLocal) {
                    ((CursoAvanceDTO *)foundObject).avance = [NSNumber numberWithInt:avanceServidor];
                    
                    if ([foundObject isKindOfClass:[CursoAvanceDTO class]]) {
                        [coreDataController updateCursoAvance:storedRecords[i] withData:foundObject];
                    }else if([foundObject isKindOfClass:[PalabraAvanceDTO class]]){
                        [coreDataController updatePalabraAvance:storedRecords[i] withData:foundObject];
                    }
                    
                    [serverObjectsLeftToSync removeObject:foundObject];
                    
                // SI GANA LOCAL, pusheamos
                }else{
                    [objectsToPush addObject:foundObject];
                }
				
                
                // CREATE
			}else if(!storedManagedObject){
				id foundObject = serverObjectsLeftToSync.lastObject;
				
				if ([foundObject isKindOfClass:[CursoAvanceDTO class]]) {
                    CursoAvanceDTO *cursoAvanceDTO = foundObject;
                    CursoDTO *cursoDTO = (CursoDTO *)[[cursoAvanceDTO objectForKey:@"curso"] fetchIfNeeded];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId like %@",cursoDTO.objectId];
                    Curso *curso = [coreDataController getObjectForClass:kCursoClass predicate:predicate];
					[coreDataController insertCursoAvance:foundObject curso:curso];
				}else if([foundObject isKindOfClass:[PalabraAvanceDTO class]]){
                    PalabraAvanceDTO *cursoAvanceDTO = foundObject;
                    PalabraDTO *cursoDTO = (PalabraDTO *)[[cursoAvanceDTO objectForKey:@"palabra"] fetchIfNeeded];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId like %@",cursoDTO.objectId];
                    Palabra *palabra = [coreDataController getObjectForClass:kPalabraClass predicate:predicate];
					[coreDataController insertPalabraAvance:foundObject palabra:palabra];
				}
				
				[serverObjectsLeftToSync removeLastObject];
			}
			
		}
        
        // PUSH LOCALLY CREATED FILES AND THE FUCKING ARRAY TO PUSH
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sincronizado == %d",kSincronizacionEstadoInsertado];
        NSArray *locallyCreated = [coreDataController getObjectForClass:class predicate:predicate];
        
        for (id object in locallyCreated) {
            if ([object isKindOfClass:[CursoAvance class]]) {
                
                [objectsToPush addObject:[self createCursoAvance:coreDataController.usuarioActivo curso:object]];
            }else if ([object isKindOfClass:[PalabraAvance class]]){
                
                [objectsToPush addObject:[self createPalabraAvance:coreDataController.usuarioActivo palabra:object]];
            }
        }
        NSLog(@"%@",objectsToPush);
        [PFObject saveAllInBackground:objectsToPush block:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                NSLog(@"%@",error);
            }
            NSLog(@"%@",objectsToPush);
        }];
        
        
		[coreDataController saveBackgroundContext];
		[coreDataController saveMasterContext];
		NSArray *toredRecords = [coreDataController managedObjectsForClass:class];
		NSLog(@"Result %@: %@",class,toredRecords);
		handler();
    }];
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
        cursoAvanceDTO.cursoId = cursoAvance.curso.objectId;
        cursoAvanceDTO.palabrasCompletas = cursoAvance.palabrasCompletas;
        cursoAvanceDTO.tiempoEstudiado = cursoAvance.tiempoEstudiado;
        cursoAvanceDTO.ultimaSincronizacion = [NSDate date];
        cursoAvanceDTO.usuarioId = cursoAvance.usuario.objectId;
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
        palabraAvanceDTO.palabraId = palabraAvance.palabra.objectId;
        palabraAvanceDTO.prioridad = palabraAvance.prioridad;
        palabraAvanceDTO.ultimaFechaRepaso = palabraAvance.ultimaFechaRepaso;
        palabraAvanceDTO.ultimaSincronizacion = [NSDate date];
        palabraAvanceDTO.usuarioId = palabraAvance.usuario.objectId;
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
	
	NSArray *storedRecords = [coreDataController managedObjectsForClass:kPalabraAvanceClass];
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
             CoreDataController *coredataController = [CoreDataController sharedInstance];
			  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"curso.objectId like %@",curso.objectId];
			  NSArray *storedPalabras = [coredataController managedObjectsForClass:kPalabraClass predicate:predicate];
			  Usuario *usuario = [coredataController usuarioActivo];
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
							  [coredataController insertCursoAvance:object curso:curso];
						  }else if ([object isKindOfClass:[PalabraAvanceDTO class]]){
                              PalabraAvanceDTO *palabraAvanceDTO = object;
                              NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId like %@",palabraAvanceDTO.palabraId];
                              Palabra *palabra = [[CoreDataController sharedInstance] getObjectForClass:kPalabraClass predicate:predicate];
							  [coredataController insertPalabraAvance:object palabra:palabra];
						  }
						  
					  }
                      [[CoreDataController sharedInstance] saveBackgroundContext];
                      [[CoreDataController sharedInstance] saveMasterContext];
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
//    [self masterMasterSyncForClass:kPalabraAvanceClass columnName:@"palabra" objectId:curso.objectId block:^{
        handler();
//    }];
}
- (void)finalizarLeccion:(Curso *)curso completion:(void(^)())handler
{
	// Actualizar avance del curso y avance de las palabras del curso
    [self masterMasterSyncForClass:kCursoAvanceClass
                        columnName:@"curso"
                          objectId:curso.objectId
                             block:^{
        [self masterMasterSyncForClass:kPalabraAvanceClass
                            columnName:@"palabra"
                              objectId:curso.objectId
                                 block:^{
            handler();
        }];
    }];
    
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

@end
