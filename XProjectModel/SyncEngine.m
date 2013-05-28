//
//  SyncEngine.m
//  iSpeak
//
//  Created by Paul on 16/05/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import "SyncEngine.h"
#import "CoreDataController.h"
#import "ParseUtilities.h"
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
- (void)createCursoAvance:(Usuario *)usuario Curso:(Curso *)curso
{
	CursoAvanceDTO *cursoAvance = [[CursoAvanceDTO alloc] init];
    cursoAvance.usuario = usuario.objectId;
    cursoAvance.avance = [NSNumber numberWithInt:0];
    cursoAvance.palabrasComenzadas = [NSNumber numberWithInt:0];
    cursoAvance.palabrasCompletas = [NSNumber numberWithInt:0];
    cursoAvance.tiempoEstudiado = [NSNumber numberWithInt:0];
    cursoAvance.ultimaSincronizacion = [NSDate date];
    cursoAvance.sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoSincronizado];
    cursoAvance.curso = curso.objectId;
    
    [CursoAvanceParse insertCursoAvance:cursoAvance completion:^(NSString *cursoAvanceId) {
        cursoAvance.objectId = cursoAvanceId;
        if(cursoAvance.objectId != nil)
        {
            cursoAvance.sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoInsertado];
            [[CoreDataController sharedInstance] insertCursoAvance:cursoAvance];
        }
    }];
}
- (void)createPalabraAvance:(Usuario *)usuario Palabra:(Palabra *)palabra
{
	PalabraAvanceDTO *palabraAvance = [[PalabraAvanceDTO alloc]init];
    palabraAvance.usuario = usuario.objectId;
    palabraAvance.avance = [NSNumber numberWithInt:0];
    palabraAvance.estado = [NSNumber numberWithInt:0];
    palabraAvance.prioridad = [NSNumber numberWithInt:0];
    palabraAvance.ultimaFechaRepaso = [NSDate date];
    palabraAvance.ultimaSincronizacion = [NSDate date];
    palabraAvance.sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoSincronizado];
    palabraAvance.palabra = palabra.objectId;

    [PalabraAvanceParse insertPalabraAvance:palabraAvance completion:^(NSString *palabraAvanceId) {
        palabraAvance.objectId = palabraAvanceId;
        
        if(palabraAvance.objectId != nil)
        {
            palabraAvance.sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoInsertado];
            [[CoreDataController sharedInstance] insertPalabraAvance:palabraAvance];
        }
    }];
}

- (void)syncCursos:(void(^)())handler
{
	//NSDate *mostRecentUpdatedDate = nil;
	CoreDataController *coreDataController = [CoreDataController sharedInstance];
	
	//mostRecentUpdatedDate = [self mostRecentUpdatedAtDateForEntityWithName:className];
	
	NSArray *storedRecords = [coreDataController managedObjectsForClass:kCursoClass];
	NSLog(@"Stored: %@",storedRecords);
	
	[CursoParse selectCursoAll:^(NSArray *cursos) {
		NSLog(@"Parse: %@",cursos);
        NSMutableArray *idsCursos = [[NSMutableArray alloc] init];
        for (CursoDTO *curso in cursos){
            [idsCursos addObject:curso.objectId];
        }
		int currentIndex = 0;
		for (CursoDTO *curso in cursos) {
			NSManagedObject *storedManagedObject = nil;
			if ([storedRecords count] > currentIndex) {
				storedManagedObject = [storedRecords objectAtIndex:currentIndex];
			}
			if ([idsCursos containsObject:[storedManagedObject valueForKey:@"objectId"]]) {
				NSString *idCurso = [storedManagedObject valueForKey:@"objectId"];
				[coreDataController updateCurso:[cursos objectAtIndex:[idsCursos indexOfObject:idCurso]]];
			}else{
				[coreDataController insertCurso:curso];
			}
			currentIndex++;
			
		}
		[coreDataController saveBackgroundContext];
		handler();
	}];
}

- (void)syncCursoAvance:(NSArray *)storedRecords
{
    for(CursoAvance *cursoAvance in storedRecords)
    {
        CursoAvanceDTO *cursoAvanceDTO = [[CursoAvanceDTO alloc] init];
        cursoAvanceDTO.avance = cursoAvance.avance;
        cursoAvanceDTO.palabrasComenzadas = cursoAvance.palabrasComenzadas;
        cursoAvanceDTO.curso = cursoAvance.curso.objectId;
        cursoAvanceDTO.palabrasCompletas = cursoAvance.palabrasCompletas;
        cursoAvanceDTO.tiempoEstudiado = cursoAvance.tiempoEstudiado;
        cursoAvanceDTO.ultimaSincronizacion = [NSDate date];
        cursoAvanceDTO.usuario = cursoAvance.usuario.objectId;
        cursoAvanceDTO.sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoSincronizado];
        [CursoAvanceParse insertCursoAvance:cursoAvanceDTO completion:^(NSString *cursoAvanceId) {
            [[CoreDataController sharedInstance] updateCursoAvance:cursoAvanceDTO];
        }];
    }
}


- (void)syncCursoAvanceConUsuario:(Usuario *)usuario Curso:(Curso *)curso completion:(void(^)())handler
{
	CoreDataController *coreDataController = [CoreDataController sharedInstance];
	
	//mostRecentUpdatedDate = [self mostRecentUpdatedAtDateForEntityWithName:className];
	
	NSArray *storedRecords = [coreDataController managedObjectsForClass:kCursoAvanceClass];
	NSLog(@"Stored: %@",storedRecords);
	
	[CursoAvanceParse selectCursoAvanceByUserID:usuario.objectId cursoID:curso.objectId completion:^(NSArray *cursoAvances) {
		NSLog(@"Parse: %@",cursoAvances);
        NSMutableArray *idsCursoAvances = [[NSMutableArray alloc] init];
        for (CursoAvanceDTO *cursoAvance in cursoAvances){
            [idsCursoAvances addObject:cursoAvance.objectId];
        }
		int currentIndex = 0;
		for (CursoAvanceDTO *cursoAvance in cursoAvances) {
			NSManagedObject *storedManagedObject = nil;
			if ([storedRecords count] > currentIndex) {
				storedManagedObject = [storedRecords objectAtIndex:currentIndex];
			}
			if ([idsCursoAvances containsObject:[storedManagedObject valueForKey:@"objectId"]]) {
				NSString *idCurso = [storedManagedObject valueForKey:@"objectId"];
				[coreDataController updateCursoAvance:[cursoAvances objectAtIndex:[idsCursoAvances indexOfObject:idCurso]]];
			}else{
				[coreDataController insertCursoAvance:cursoAvance];
			}
			currentIndex++;
			
		}
		[coreDataController saveBackgroundContext];
		handler();
	}];
}

- (void)syncCursoAvanceConUsuario:(Usuario *)usuario completion:(void(^)())handler
{
	CoreDataController *coreDataController = [CoreDataController sharedInstance];
	
	//mostRecentUpdatedDate = [self mostRecentUpdatedAtDateForEntityWithName:className];
	
	NSArray *storedRecords = [coreDataController managedObjectsForClass:kCursoAvanceClass];
	NSLog(@"Stored: %@",storedRecords);
	
	[CursoAvanceParse selectCursoAvanceAllByUserID:usuario.objectId completion:^(NSArray *cursoAvances) {
		NSLog(@"Parse: %@",cursoAvances);
        NSMutableArray *idsCursoAvances = [[NSMutableArray alloc] init];
        for (CursoAvanceDTO *cursoAvance in cursoAvances){
            [idsCursoAvances addObject:cursoAvance.objectId];
        }
		int currentIndex = 0;
		for (CursoAvanceDTO *cursoAvance in cursoAvances) {
			NSManagedObject *storedManagedObject = nil;
			if ([storedRecords count] > currentIndex) {
				storedManagedObject = [storedRecords objectAtIndex:currentIndex];
			}
			if ([idsCursoAvances containsObject:[storedManagedObject valueForKey:@"objectId"]]) {
				NSString *idCurso = [storedManagedObject valueForKey:@"objectId"];
				[coreDataController updateCursoAvance:[cursoAvances objectAtIndex:[idsCursoAvances indexOfObject:idCurso]]];
			}else{
				//[coreDataController insertCursoAvance:cursoAvance];
			}
			currentIndex++;
			
		}
		[coreDataController saveBackgroundContext];
		handler();
	}];
}
- (void)syncPalabras:(Curso*)curso completion:(void(^)())handler
{
	CoreDataController *coreDataController = [CoreDataController sharedInstance];
	
	//mostRecentUpdatedDate = [self mostRecentUpdatedAtDateForEntityWithName:className];
	
	NSArray *storedRecords = [coreDataController managedObjectsForClass:kPalabraClass];
	NSLog(@"Stored: %@",storedRecords);
	
	[PalabraParse selectPalabraAllByCursoID:curso.objectId completion:^(NSArray *palabras) {
		NSLog(@"Parse: %@",palabras);
        NSMutableArray *idsPalabras = [[NSMutableArray alloc] init];
        for (PalabraDTO *palabra in palabras){
            [idsPalabras addObject:palabra.objectId];
        }
		int currentIndex = 0;
		for (PalabraDTO *palabra in palabras) {
			NSManagedObject *storedManagedObject = nil;
			if ([storedRecords count] > currentIndex) {
				storedManagedObject = [storedRecords objectAtIndex:currentIndex];
			}
			if ([idsPalabras containsObject:[storedManagedObject valueForKey:@"objectId"]]) {
				NSString *idCurso = [storedManagedObject valueForKey:@"objectId"];
				[coreDataController updatePalabra:[palabras objectAtIndex:[idsPalabras indexOfObject:idCurso]]];
			}else{
				[coreDataController insertPalabra:palabra];
			}
			currentIndex++;
			
		}
		[coreDataController saveBackgroundContext];
		handler();
	}];
}
- (void)syncOraciones:(Palabra*)palabra completion:(void(^)())handler
{
	CoreDataController *coreDataController = [CoreDataController sharedInstance];
	
	//mostRecentUpdatedDate = [self mostRecentUpdatedAtDateForEntityWithName:className];
	
	NSArray *storedRecords = [coreDataController managedObjectsForClass:kOracionClass];
	NSLog(@"Stored: %@",storedRecords);
	
	[OracionParse selectOracionAllByPalabraID:palabra.objectId completion:^(NSArray *oraciones) {
		NSLog(@"Parse: %@",oraciones);
        NSMutableArray *idsOraciones = [[NSMutableArray alloc] init];
        for (OracionDTO *oracion in oraciones){
            [idsOraciones addObject:oracion.objectId];
        }
		int currentIndex = 0;
		for (OracionDTO *oracion in oraciones) {
			NSManagedObject *storedManagedObject = nil;
			if ([storedRecords count] > currentIndex) {
				storedManagedObject = [storedRecords objectAtIndex:currentIndex];
			}
			if ([idsOraciones containsObject:[storedManagedObject valueForKey:@"objectId"]]) {
				NSString *idCurso = [storedManagedObject valueForKey:@"objectId"];
				[coreDataController updateOracion:[oraciones objectAtIndex:[idsOraciones indexOfObject:idCurso]]];
			}else{
				[coreDataController insertOracion:oracion];
			}
			currentIndex++;
			
		}
		[coreDataController saveBackgroundContext];
		handler();
	}];
}
- (void)syncPalabraAvance:(NSArray *)storedRecords
{
    for(PalabraAvance *palabraAvance in storedRecords)
    {
        PalabraAvanceDTO *palabraAvanceDTO = [[PalabraAvanceDTO alloc] init];
        palabraAvanceDTO.avance = palabraAvance.avance;
        palabraAvanceDTO.estado = palabraAvance.estado;
        palabraAvanceDTO.palabra = palabraAvance.palabra.objectId;
        palabraAvanceDTO.prioridad = palabraAvance.prioridad;
        palabraAvanceDTO.ultimaFechaRepaso = palabraAvance.ultimaFechaRepaso;
        palabraAvanceDTO.ultimaSincronizacion = [NSDate date];
        palabraAvanceDTO.usuario = palabraAvance.usuario.objectId;
        palabraAvanceDTO.sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoSincronizado];
        [PalabraAvanceParse insertPalabraAvance:palabraAvanceDTO completion:^(NSString *palabraAvanceId) {
            [[CoreDataController sharedInstance] updatePalabraAvance:palabraAvanceDTO];
        }];
    }
}
- (void)syncPalabraAvanceConUsuario:(Usuario *)usuario Palabra:(Palabra*)palabra completion:(void(^)())handler
{
	CoreDataController *coreDataController = [CoreDataController sharedInstance];
	
	//mostRecentUpdatedDate = [self mostRecentUpdatedAtDateForEntityWithName:className];
	
	NSArray *storedRecords = [coreDataController managedObjectsForClass:kPalabraClass];
	NSLog(@"Stored: %@",storedRecords);
	
	[PalabraAvanceParse selectPalabraAvanceByUserID:usuario.objectId palabraID:palabra.objectId completion:^(NSArray *palabraAvances) {
		NSLog(@"Parse: %@",palabraAvances);
        NSMutableArray *idsPalabraAvances = [[NSMutableArray alloc] init];
        for (PalabraAvanceDTO *palabraAvance in palabraAvances){
            [idsPalabraAvances addObject:palabraAvance.objectId];
        }
		int currentIndex = 0;
		for (PalabraAvanceDTO *palabraAvance in palabraAvances) {
			NSManagedObject *storedManagedObject = nil;
			if ([storedRecords count] > currentIndex) {
				storedManagedObject = [storedRecords objectAtIndex:currentIndex];
			}
			if ([idsPalabraAvances containsObject:[storedManagedObject valueForKey:@"objectId"]]) {
				NSString *idCurso = [storedManagedObject valueForKey:@"objectId"];
				[coreDataController updatePalabraAvance:[palabraAvances objectAtIndex:[idsPalabraAvances indexOfObject:idCurso]]];
			}else{
				[coreDataController insertPalabraAvance:palabraAvance];
			}
			currentIndex++;
			
		}
		[coreDataController saveBackgroundContext];
		handler();
	}];
}


#pragma mark - SyncEngine Specifics

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


- (void)seAcabaDeLoguear:(Usuario *)usuario completion:(void(^)())handler
{
	// Descargar/Actualizar todos los cursos
	// Descargar/Actualizar todos los avances de cursos
	[self syncCursos:^{
		
		[self syncCursoAvanceConUsuario:usuario completion:^{
			
			handler();
			
		}];
	}];
	
	
}
- (void)iniciarCurso:(Curso *)curso completion:(void(^)())handler
{
	// Descargar palabras y oraciones del curso
	// Insertar avances de palabras y avances del curso
    [self syncPalabras:curso completion:^{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"curso.objectId like %@",curso.objectId];
        NSArray *storedPalabras = [[CoreDataController sharedInstance] managedObjectsForClass:kPalabraClass predicate:predicate];
        for(Palabra *palabra in storedPalabras){
            [self syncOraciones:palabra completion:^{
            }];
            [self createPalabraAvance:[[CoreDataController sharedInstance] usuarioActivo] Palabra:palabra];
        }
        [self createCursoAvance:[[CoreDataController sharedInstance] usuarioActivo] Curso:curso];
    }];
}
- (void)iniciarRepaso:(Curso *)curso
{
	// Descargar/Actualizar palabras y oraciones del curso
	// Actualizar avances de palabras
    [self syncPalabras:curso completion:^{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"curso.objectId like %@",curso.objectId];
        NSArray *storedPalabras = [[CoreDataController sharedInstance] managedObjectsForClass:kPalabraClass predicate:predicate];
        for(Palabra *palabra in storedPalabras){
            [self syncOraciones:palabra completion:^{
            }];
            [self syncPalabraAvanceConUsuario:[[CoreDataController sharedInstance] usuarioActivo] Palabra:palabra completion:^{
            }];
        }
    }];
}
- (void)finalizarLeccion:(Curso *)curso
{
	// Actualizar avance del curso y avance de las palabras del curso
    [self syncCursoAvanceConUsuario:[[CoreDataController sharedInstance] usuarioActivo] Curso:curso completion:^{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"curso.objectId like %@",curso.objectId];
        NSArray *storedPalabras = [[CoreDataController sharedInstance] managedObjectsForClass:kPalabraClass predicate:predicate];
        for(Palabra *palabra in storedPalabras){
            [self syncPalabraAvanceConUsuario:[[CoreDataController sharedInstance] usuarioActivo] Palabra:palabra completion:^{
                
            }];
        }
    }];
}
- (void)elInternetRegreso
{
	// Actualizar avance de todos los cursos y avance de todas las palabras NO SINCRONIZADAS
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sincronizado not like %@",kSincronizacionEstadoSincronizado];
    
    
    NSArray *storedPalabras = [[CoreDataController sharedInstance] managedObjectsForClass:kPalabraAvanceClass predicate:predicate];
    [self syncPalabraAvance:storedPalabras];
    
    
    NSArray *storedCursos = [[CoreDataController sharedInstance] managedObjectsForClass:kCursoAvanceClass predicate:predicate];
    [self syncCursoAvance:storedCursos];
}


@end
