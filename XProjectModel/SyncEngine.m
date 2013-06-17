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
	CursoAvanceDTO *cursoAvanceDTO = [CursoAvanceDTO object];
	cursoAvanceDTO.avance = [NSNumber numberWithInt:0];
    cursoAvanceDTO.palabrasComenzadas = [NSNumber numberWithInt:0];
    cursoAvanceDTO.palabrasCompletas = [NSNumber numberWithInt:0];
    cursoAvanceDTO.tiempoEstudiado = [NSNumber numberWithInt:0];
    cursoAvanceDTO.sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoSincronizado];
    cursoAvanceDTO.palabrasTotales = [NSNumber numberWithInt:curso.palabras.count];
	
    cursoAvanceDTO.usuario = [UsuarioDTO objectWithoutDataWithObjectId:usuario.objectId];
	cursoAvanceDTO.curso = [CursoDTO objectWithoutDataWithObjectId:curso.objectId];
	return cursoAvanceDTO;
}
- (PalabraAvanceDTO *)createPalabraAvance:(Usuario *)usuario palabra:(Palabra *)palabra curso:(NSString*)curso
{
	PalabraAvanceDTO *palabraAvanceDTO = [PalabraAvanceDTO object];
    palabraAvanceDTO.avance = [NSNumber numberWithInt:0];
    palabraAvanceDTO.estado = [NSNumber numberWithInt:0];
    palabraAvanceDTO.prioridad = [NSNumber numberWithInt:0];
    palabraAvanceDTO.ultimaFechaRepaso = [NSDate date];
    palabraAvanceDTO.sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoSincronizado];
	
    palabraAvanceDTO.usuario = [UsuarioDTO objectWithoutDataWithObjectId:usuario.objectId];
    palabraAvanceDTO.palabra = [PalabraDTO objectWithoutDataWithObjectId:palabra.objectId];
	palabraAvanceDTO.curso = [CursoDTO objectWithoutDataWithObjectId:curso];
	
	return palabraAvanceDTO;
}

#pragma mark - SyncEngine Dirty Job
- (void)masterSubordinateSyncForClass:(NSString *)class
								block:(void(^)())handler{
	[self masterSubordinateSyncForClass:class pointerColumnName:nil pointerClassName:nil pointerObjectId:nil block:handler];
}
- (void)masterSubordinateSyncForClass:(NSString *)class
					pointerColumnName:(NSString *)pointerColumnName
					 pointerClassName:(NSString *)pointerClassName
					  pointerObjectId:(NSString *)pointerObjectId
								block:(void(^)())handler
{
    
	CoreDataController *coreDataController = [CoreDataController sharedInstance];
    NSPredicate *pred;
    if ([class isEqualToString:kPalabraClass]) {
        
        pred = [NSPredicate predicateWithFormat:@"curso.objectId like %@",pointerObjectId];
    }else if ([class isEqualToString:kOracionClass]){
        
        pred = [NSPredicate predicateWithFormat:@"palabra.curso.objectId like %@",pointerObjectId];
    }
	NSArray *storedRecords = [coreDataController managedObjectsForClass:class predicate:pred sortKey:@"ultimaSincronizacion" ascending:YES];
	
	NSDate *lastUpdatedDate = ((Curso*)storedRecords.lastObject).ultimaSincronizacion;
	
	// Obtener todos los objetos que hallan sido actualizados despues de la ultima fecha de actualizacion
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"updatedAt > %@",lastUpdatedDate];
    PFQuery *query = (lastUpdatedDate)?
		[PFQuery queryWithClassName:class predicate:predicate]:
		[PFQuery queryWithClassName:class];
	
	if (pointerClassName && pointerColumnName && pointerObjectId) {
		[query whereKey:pointerColumnName equalTo:[PFObject objectWithoutDataWithClassName:pointerClassName objectId:pointerObjectId]];
	}
    [query findObjectsInBackgroundWithBlock:^(NSArray *serverObjects, NSError *error) {
        
        int nCreatedLocal = 0;
        int nUpdatedLocal = 0;
        
		if (error) {
			NSLog(@"%@",error);
			handler();
			return ;
		}
        if (!serverObjects.count) {
			handler();
			return ;
		}
		NSMutableArray *serverObjectsLeftToSync = serverObjects.mutableCopy;
        NSMutableArray *serverObjectsIDs = [[NSMutableArray alloc] init];
        for (PFObject *object in serverObjects){
            [serverObjectsIDs addObject:object.objectId];
        }
		int max = (storedRecords.count>serverObjects.count) ? storedRecords.count : serverObjects.count;
		
        NSMutableArray *foundObjects = [[NSMutableArray alloc] init];
        NSMutableArray *fetchIfNeededObjects = [[NSMutableArray alloc] init];
		for (int i=0;i<max;i++) {
			NSManagedObject *storedManagedObject = (storedRecords.count > i)? storedRecords[i] : nil;
			
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
                nUpdatedLocal++;
				[serverObjectsLeftToSync removeObject:foundObject];
			
			// CREATE
			}else if(!storedManagedObject){
				id foundObject = serverObjectsLeftToSync.lastObject;
				
				[foundObjects addObject:foundObject];
				if ([foundObject isKindOfClass:[CursoDTO class]]) {
					[coreDataController insertCurso:foundObject];
				}else if([foundObject isKindOfClass:[PalabraDTO class]]){
					
					[fetchIfNeededObjects addObject:[foundObject objectForKey:@"curso"]];
				}else if([foundObject isKindOfClass:[OracionDTO class]]){
					
					[fetchIfNeededObjects addObject:[foundObject objectForKey:@"palabra"]];
                    
				}
				nCreatedLocal++;
				[serverObjectsLeftToSync removeLastObject];
			}
			
		}
		[PFObject fetchAllIfNeeded:fetchIfNeededObjects];
		
		for (id foundObject in foundObjects) {
			if ([foundObject isKindOfClass:[CursoDTO class]]) {
				
			}else if([foundObject isKindOfClass:[PalabraDTO class]]){
				
				PalabraDTO *palabraDTO = foundObject;
				
				
				CursoDTO *cursoDTO = (CursoDTO *)[[palabraDTO objectForKey:@"curso"] fetchIfNeeded];
				NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId like %@",cursoDTO.objectId];
				Curso *curso = [coreDataController getObjectForClass:kCursoClass predicate:predicate];
				[coreDataController insertPalabra:palabraDTO curso:curso];
			}else if([foundObject isKindOfClass:[OracionDTO class]]){
				
				OracionDTO *oracionDTO = foundObject;
				PalabraDTO *cursoDTO = (PalabraDTO *)[[oracionDTO objectForKey:@"palabra"] fetchIfNeeded];
				NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId like %@",cursoDTO.objectId];
				Palabra *palabra = [coreDataController getObjectForClass:kPalabraClass predicate:predicate];
				[coreDataController insertOracion:foundObject palabra:palabra];
			}
		}
		[coreDataController saveBackgroundContext];
		[coreDataController saveMasterContext];
		
		if (nCreatedLocal+nUpdatedLocal) {
		NSLog(@"Stored %@: %d",class,storedRecords.count);
        NSLog(@"Parse %@: %d",class,serverObjects.count);
        NSLog(@"Summary %@: CLocal %d; ULocal %d;",class,nCreatedLocal,nUpdatedLocal);
		NSLog(@"--------");
		}
		
		handler();
    }];
}
- (void)masterMasterSyncForClass:(NSString *)class
						   block:(void(^)())handler
{
	[self masterMasterSyncForClass:class
				 pointerColumnName:nil
				  pointerClassName:nil
				   pointerObjectId:nil
							 block:handler];
}
- (void)masterMasterSyncForClass:(NSString *)class
			   pointerColumnName:(NSString *)pointerColumnName
				pointerClassName:(NSString *)pointerClassName
				 pointerObjectId:(NSString *)pointerObjectId
						   block:(void(^)())handler
{
    // Ok so, this is the plan
    // 1. Download todos los objetos actualizados despues de la ultima fecha de sync
    // 2. Recorremos los objetos
    // 3. Si es nuevo insertar
    // 4. si no, si gana servidor -> actualizar (resolver conflictos, tomar mayor porcentaje)
    // 5. si no, si gana local -> pushear
    // 6. Despues de todo eso, -> pushear nuevos creados localmente
    
    
	CoreDataController *coreDataController = [CoreDataController sharedInstance];
	NSPredicate *pred;
    if ([class isEqualToString:kCursoAvanceClass]) {
        pred = nil;
    }else if ([class isEqualToString:kPalabraAvanceClass]){        
        pred = [NSPredicate predicateWithFormat:@"palabra.curso.objectId like %@",pointerObjectId];
    }
	
	NSArray *storedRecords = [coreDataController managedObjectsForClass:class predicate:pred sortKey:@"ultimaSincronizacion" ascending:YES];
	
    NSDate *lastUpdatedDate = ((CursoAvance*)storedRecords.lastObject).ultimaSincronizacion;

    // Obtener todos los objetos que hallan sido actualizados despues de la ultima fecha de actualizacion
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"updatedAt > %@",lastUpdatedDate];
    PFQuery *query = (lastUpdatedDate)?
		[PFQuery queryWithClassName:class predicate:predicate]:
		[PFQuery queryWithClassName:class];
    
	if (pointerClassName && pointerColumnName && pointerObjectId) {
		[query whereKey:pointerColumnName equalTo:[PFObject objectWithoutDataWithClassName:pointerClassName objectId:pointerObjectId]];
	}
    [query findObjectsInBackgroundWithBlock:^(NSArray *serverObjects, NSError *error) {
        int nCreatedServer = 0;
        int nUpdatedServer = 0;
        int nCreatedLocal = 0;
        int nUpdatedLocal = 0;
        
		if (error) {
			NSLog(@"%@",error);
			handler();
			return ;
		}
		
        NSMutableArray *objectsToPush = [[NSMutableArray alloc] init];
		NSMutableArray *serverObjectsLeftToSync = serverObjects.mutableCopy;
        NSMutableArray *serverObjectsIDs = [[NSMutableArray alloc] init];
        for (PFObject *object in serverObjects){
            [serverObjectsIDs addObject:object.objectId];
        }
		int max = (storedRecords.count>serverObjects.count) ? storedRecords.count : serverObjects.count;
		
        NSMutableArray *foundObjects = [[NSMutableArray alloc] init];
        NSMutableArray *fetchIfNeededObjects = [[NSMutableArray alloc] init];
		for (int i=0;i<max;i++) {
			NSManagedObject *storedManagedObject = (storedRecords.count > i)? storedRecords[i] : nil;
			
			// UPDATE
			// si encuentra un id jalado de parse q es igual al guardado en storedRecords[currentIndex]
			if ([serverObjectsIDs containsObject:[storedManagedObject valueForKey:@"objectId"]]) {
				NSString *idObject = [storedManagedObject valueForKey:@"objectId"];
				id foundObject = [serverObjects objectAtIndex:[serverObjectsIDs indexOfObject:idObject]];
				
                int avanceLocal = ((CursoAvance *)storedRecords[i]).avance.intValue;
                int avanceServidor = ((CursoAvanceDTO *)foundObject).avance.intValue;
                
                // SI GANA SERVIDOR, guardamos
                if (avanceServidor>=avanceLocal) {
                    ((CursoAvanceDTO *)foundObject).avance = [NSNumber numberWithInt:avanceServidor];
                    
                    if ([foundObject isKindOfClass:[CursoAvanceDTO class]]) {
                        [coreDataController updateCursoAvance:storedRecords[i] withData:foundObject];
                        
                    }else if([foundObject isKindOfClass:[PalabraAvanceDTO class]]){
                        [coreDataController updatePalabraAvance:storedRecords[i] withData:foundObject];
                        
                    }
                    nUpdatedLocal++;
                    [serverObjectsLeftToSync removeObject:foundObject];
                    
                // SI GANA LOCAL, pusheamos
                }else{
                    [objectsToPush addObject:foundObject];
                    nUpdatedServer++;
                }
				
                
                // CREATE
			}else if(!storedManagedObject){
				id foundObject = serverObjectsLeftToSync.lastObject;
				[foundObjects addObject:foundObject];
				if ([foundObject isKindOfClass:[CursoAvanceDTO class]]) {
                    
					
					[fetchIfNeededObjects addObject:[foundObject objectForKey:@"curso"]];
                    
				}else if([foundObject isKindOfClass:[PalabraAvanceDTO class]]){
                    
					[fetchIfNeededObjects addObject:[foundObject objectForKey:@"palabra"]];
				}
				
				nCreatedLocal++;
				[serverObjectsLeftToSync removeLastObject];
			}
			
		}
		
		[PFObject fetchAllIfNeeded:fetchIfNeededObjects];
		
		for (id foundObject in foundObjects) {
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
		}
		
        
        // PUSH LOCALLY CREATED FILES AND THE FUCKING ARRAY TO PUSH
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sincronizado == %d",kSincronizacionEstadoInsertado];
        NSArray *locallyCreated = [coreDataController managedObjectsForClass:class predicate:predicate];
        
        for (id object in locallyCreated) {
			
            nCreatedServer++;
            if ([object isKindOfClass:[CursoAvance class]]) {
                
                [objectsToPush addObject:[self createCursoAvance:coreDataController.usuarioActivo curso:object]];
            }else if ([object isKindOfClass:[PalabraAvance class]]){
                
                [objectsToPush addObject:[self createPalabraAvance:coreDataController.usuarioActivo palabra:object curso:pointerObjectId]];
            }
        }
		if (objectsToPush.count) {
			
			[PFObject saveAllInBackground:objectsToPush block:^(BOOL succeeded, NSError *error) {
				if (!succeeded) {
					NSLog(@"%@",error);
				}else{
					for (id object in locallyCreated) {
						((PalabraAvance*)object).sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoSincronizado];
					}
				}
			}];
			
		}else{
			
			[coreDataController saveBackgroundContext];
			[coreDataController saveMasterContext];
		}
        
        
        
		
		if (nCreatedLocal+nUpdatedLocal+nCreatedServer+nUpdatedServer) {
			NSLog(@"Stored %@: %d",class,storedRecords.count);
			NSLog(@"Parse %@: %d",class,serverObjects.count);
			NSLog(@"Summary %@: CLocal %d; ULocal %d; CServ %d; UServ %d;",class,nCreatedLocal,nUpdatedLocal,nCreatedServer,nUpdatedServer);
			NSLog(@"--------");
		}
		
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

#pragma mark - SyncEngine Scenario Methods

- (void)seAcabaDeLoguear:(Usuario *)usuario completion:(void(^)())handler
{
    NSLog( @"%@" , NSStringFromSelector(_cmd) );
	// Descargar/Actualizar todos los cursos
	// Descargar/Actualizar todos los avances de cursos
	[self masterSubordinateSyncForClass:kCursoClass block:^{
		
		[self masterMasterSyncForClass:kCursoAvanceClass
					 pointerColumnName:@"usuario"
					  pointerClassName:kUsuarioClass
					   pointerObjectId:usuario.objectId
								 block:^{
			
			handler();
			
		}];
	}];
	
	
}
- (void)iniciarCurso:(Curso *)curso createCursoPalabraAvance:(BOOL)create completion:(void(^)())handler
{
	// Descargar palabras y oraciones del curso
	// Insertar avances de palabras y avances del curso
	[self masterSubordinateSyncForClass:kPalabraClass
					  pointerColumnName:@"curso"
					   pointerClassName:kCursoClass
						pointerObjectId:curso.objectId
								  block:^{
		
		[self masterSubordinateSyncForClass:kOracionClass
						  pointerColumnName:@"curso"
						   pointerClassName:kCursoClass
							pointerObjectId:curso.objectId
									  block:
		 ^{
             [self masterMasterSyncForClass:kPalabraAvanceClass
                          pointerColumnName:@"curso"
                           pointerClassName:kCursoClass
                            pointerObjectId:curso.objectId
                                      block:
              ^{
             if (create) {
                 // CREATE curso/palabra avance
                 CoreDataController *coredataController = [CoreDataController sharedInstance];
                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"curso.objectId like %@",curso.objectId];
                 NSArray *storedPalabras = [coredataController managedObjectsForClass:kPalabraClass predicate:predicate];
                 Usuario *usuario = [coredataController usuarioActivo];
                 __block NSMutableArray *dataToSave = [NSMutableArray array];
                 [dataToSave addObject:[self createCursoAvance:usuario curso:curso]];
                 for (Palabra *palabra in storedPalabras) {
                     [dataToSave addObject:[self createPalabraAvance:usuario palabra:palabra curso:curso.objectId]];
                 }
                 NSLog(@"date %@",((PalabraAvanceDTO*)dataToSave.lastObject).updatedAt);
                 NSLog(@"Created %d avance d palabra",dataToSave.count-1);
                 // PUSH
                 [PFObject saveAllInBackground:dataToSave block:
                  ^(BOOL succeeded, NSError *error){
                      if (succeeded) {
                          NSLog(@"PUSHED it!");
                          NSLog(@"date %@",((PalabraAvanceDTO*)dataToSave.lastObject).updatedAt);
                          for (id object in dataToSave) {
                              ((CursoAvanceDTO*)object).sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoSincronizado];
                              if ([object isKindOfClass:[CursoAvanceDTO class]]) {
                                  [coredataController insertCursoAvance:object curso:curso];
                              }else if ([object isKindOfClass:[PalabraAvanceDTO class]]){
                                  PalabraAvanceDTO *palabraAvanceDTO = object;
                                  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId like %@",palabraAvanceDTO.palabra.objectId];
                                  Palabra *palabra = [[CoreDataController sharedInstance] getObjectForClass:kPalabraClass predicate:predicate];
                                  [coredataController insertPalabraAvance:object palabra:palabra];
                              }
                              
                          }
                          [[CoreDataController sharedInstance] saveBackgroundContext];
                          [[CoreDataController sharedInstance] saveMasterContext];
                          handler();
                      }
                  }];
             }else{
                 [self masterMasterSyncForClass:kPalabraAvanceClass
                              pointerColumnName:@"curso"
                               pointerClassName:kCursoClass
                                pointerObjectId:curso.objectId
                                          block:
                  ^{
                      [[CoreDataController sharedInstance] saveBackgroundContext];
                      [[CoreDataController sharedInstance] saveMasterContext];
                      handler();
                   }];
                 
             }
            }];
			 
		}];
		
    }];
}
- (void)iniciarRepaso:(Curso *)curso completion:(void(^)())handler
{
	// Descargar/Actualizar palabras y oraciones del curso ==FALTA
	// Actualizar avances de palabras
    Usuario * usuario = [[CoreDataController sharedInstance] usuarioActivo];
    [self masterMasterSyncForClass:kCursoAvanceClass
				 pointerColumnName:@"usuario"
				  pointerClassName:kUsuarioClass
				   pointerObjectId:usuario.objectId
                             block:
     ^{
         [self masterMasterSyncForClass:kPalabraAvanceClass
                      pointerColumnName:@"curso"
                       pointerClassName:kCursoClass
                        pointerObjectId:curso.objectId
                                  block:^{
                                      handler();
                                  }];
         
    }];
}
- (void)finalizarLeccion:(Curso *)curso completion:(void(^)())handler
{
	// Actualizar avance del curso y avance de las palabras del curso
	Usuario * usuario = [[CoreDataController sharedInstance] usuarioActivo];
    [self masterMasterSyncForClass:kCursoAvanceClass
				 pointerColumnName:@"usuario"
				  pointerClassName:kUsuarioClass
				   pointerObjectId:usuario.objectId
                             block:^{
        [self masterMasterSyncForClass:kPalabraAvanceClass
					 pointerColumnName:@"curso"
					  pointerClassName:kCursoClass
					   pointerObjectId:curso.objectId
                                 block:^{
            handler();
        }];
    }];
    
}
- (void)elInternetRegresoCompletion:(void(^)())handler
{
	// Actualizar avance de todos los cursos y avance de todas las palabras NO SINCRONIZADAS
    [self masterMasterSyncForClass:kCursoAvanceClass block:
     ^{
         [self masterMasterSyncForClass:kPalabraAvanceClass block:
          ^{
              handler();
          }];
    }];
}

@end
