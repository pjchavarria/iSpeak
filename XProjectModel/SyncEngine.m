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
- (void)createCursoAvance:(Usuario *)usuario
{
	
}
- (void)createPalabraAvance:(Usuario *)usuario
{
	
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
		int currentIndex = 0;
		for (CursoDTO *curso in cursos) {
			NSManagedObject *storedManagedObject = nil;
			if ([storedRecords count] > currentIndex) {
				storedManagedObject = [storedRecords objectAtIndex:currentIndex];
			}
			if ([[storedManagedObject valueForKey:@"objectId"] isEqualToString:curso.objectId]) {
				
				[coreDataController updateCurso:curso];
			}else{
				[coreDataController insertCurso:curso];
			}
			currentIndex++;
			
		}
		[coreDataController saveBackgroundContext];
		handler();
	}];
}




- (void)syncCursoAvance:(Usuario *)usuario completion:(void(^)())handler
{
//	CoreDataController *coreDataController = [CoreDataController sharedInstance];
//	NSArray *storedRecords = [coreDataController managedObjectsForClass:kCursoAvanceClass predicate:[NSPredicate predicateWithFormat:@"usuario.objectId like %@",usuario.objectId]];
//	NSLog(@"Stored: %@",storedRecords);
//	
//	[CursoAvanceParse selectCursoAvanceByUserID:usuario.ob cursoID:<#(NSString *)#> completion:<#^(NSArray *cursoAvances)handler#>:^(NSArray *cursos) {
//		NSLog(@"Parse: %@",cursos);
//		int currentIndex = 0;
//		for (CursoDTO *curso in cursos) {
//			NSManagedObject *storedManagedObject = nil;
//			if ([storedRecords count] > currentIndex) {
//				storedManagedObject = [storedRecords objectAtIndex:currentIndex];
//			}
//			if ([[storedManagedObject valueForKey:@"objectId"] isEqualToString:curso.objectId]) {
//				
//				[coreDataController updateCurso:curso];
//			}else{
//				[coreDataController insertCurso:curso];
//			}
//			currentIndex++;
//			
//		}
//		[coreDataController saveBackgroundContext];
//		handler();
//	}];
	handler();
}
- (void)syncPalabras:(CursoDTO*)curso
{
	
}
- (void)syncOraciones:(CursoDTO*)curso
{
	
}
- (void)syncPalabraAvance:(Usuario *)usuario
{
	
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
		
		[self syncCursoAvance:usuario completion:^{
			
			handler();
			
		}];
	}];
	
	
}
- (void)iniciarCurso:(Curso *)curso
{
	// Descargar palabras y oraciones del curso
	// Insertar avances de palabras y avances del curso
}
- (void)iniciarRepaso:(Curso *)curso
{
	// Descargar/Actualizar palabras y oraciones del curso
	// Actualizar avances de palabras
}
- (void)finalizarLeccion:(Curso *)curso
{
	// Actualizar avance del curso y avance de las palabras del curso
}
- (void)elInternetRegreso
{
	// Actualizar avance de todos los cursos y avance de todas las palabras NO SINCRONIZADAS
}


@end
