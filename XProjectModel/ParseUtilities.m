//
//  ParseUtilities.m
//  XProjectModel
//
//  Created by Daniel Soto on 5/13/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import "ParseUtilities.h"
#import "AppDelegate.h"

@implementation ParseUtilities

@end

@implementation UsuarioParse

+ (BOOL) insertUsuario:(UsuarioDTO *)user{
    
    
    PFObject *userToInsert = [PFObject objectWithClassName:@"Usuario"];
    [userToInsert setObject:user.username forKey:@"username"];
    [userToInsert setObject:user.password forKey:@"password"];
    
  
    [userToInsert saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Success");
        } else {
			NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    return YES;
    
}
+ (BOOL) deleteUsuario:(NSString *)userID{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Usuario"];
    
    [query getObjectInBackgroundWithId:userID
                                 block:^(PFObject *userToDelete, NSError *error) {
                                     
                                     
         [userToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
              if (!error) {
                  NSLog(@"Success");
              } else {
             NSLog(@"Error: %@ %@", error, [error userInfo]);
               }
             }];

    
             }];
    
        
    return YES;
    
}
+ (BOOL) updateUsuario: (UsuarioDTO *)user{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Usuario"];
    
    [query getObjectInBackgroundWithId:user.objectId
                                 block:^(PFObject *userToUpdate, NSError *error) {
                                     
                                     [userToUpdate setObject:user.username forKey:@"username"];
                                     [userToUpdate setObject:user.password forKey:@"password"];
                                     
                                     
                                     [userToUpdate saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                         if (!error) {
                                             NSLog(@"Success");
                                         } else {
                                             NSLog(@"Error: %@ %@", error, [error userInfo]);
                                         }
                                     }];
                                     
                                      }];

    
    
    return YES;

    
}
+ (void) selectUsuario:(NSString *)userID{
    
	UsuarioDTO *userToSelect = [[UsuarioDTO alloc]init];
    

	PFQuery *query = [PFQuery queryWithClassName:@"Usuario"];
	[query getObjectInBackgroundWithId:userID
                                block:^(PFObject *userFoundParse, NSError *error) {
                                    
                                    if (!error) {
                                        
                                        userToSelect.objectId = userFoundParse.objectId;
                                        userToSelect.username = [userFoundParse objectForKey:@"username"];
                                        userToSelect.password = [userFoundParse objectForKey:@"password"];
                                         NSLog(@"%@",userToSelect);
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidLoaded" object:userToSelect];
                                        
                                                                            
                                                                            
                                    } else {
                                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                                    }
                                     }];
    
  
    
}
+ (void) selectUsuarioAll{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Usuario"];
    
    __block NSMutableArray *resultados = [[NSMutableArray alloc]init];

    
    [query findObjectsInBackgroundWithBlock:^(NSArray *usuarios, NSError *error) {
        if (!error) {
                                
            UsuarioDTO *user = [[UsuarioDTO alloc]init];
        
            for (int i=0; i<usuarios.count; i++) {
                
                PFObject *userArray = usuarios[i];
                
                user.objectId = userArray.objectId;
                user.username = [userArray objectForKey:@"username"];
                user.password = [userArray objectForKey:@"password"];
                
                [resultados addObject:user];
            }
            
            NSLog(@"Success");
          
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kListUserDidLoaded" object:resultados];
           
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];
   
    
}
+ (void) validateUsuario:(NSString *)username Password:(NSString *)password completion:(void (^) (UsuarioDTO *usuario))handler
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Usuario"];
    [query whereKey:@"username" equalTo:username];
    [query whereKey:@"password" equalTo:password];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                                     
                                     if (!error && array.count == 1) {
										 
                                         NSLog(@"Success");
										 
										 PFObject *userArray = array[0];
										 UsuarioDTO *user = [[UsuarioDTO alloc]init];
										 user.objectId = userArray.objectId;
										 user.username = [userArray objectForKey:@"username"];
										 user.password = [userArray objectForKey:@"password"];
										 handler(user);
										 
                                     } else {
                                         NSLog(@"Error: %@ %@", error, [error userInfo]);
										 handler(nil);
                                     }
                                 }];
    
}

@end

@implementation CursoParse
+ (BOOL) insertCurso:(CursoDTO *)curso{
    
    PFObject *cursoToInsert = [PFObject objectWithClassName:@"Curso"];
    
    [cursoToInsert setObject:curso.cantidadPalabras forKey:@"cantidadPalabras"];
    [cursoToInsert setObject:curso.curso forKey:@"curso"];
    [cursoToInsert setObject:curso.nombre forKey:@"nombre"];
    
    [cursoToInsert saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Success");
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    return YES;

    
}
+ (BOOL) deleteCurso:(NSString *)cursoID{
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Curso"];
    
    [query getObjectInBackgroundWithId:cursoID
                                 block:^(PFObject *cursoToDelete, NSError *error) {
                                     
                                     
                                     [cursoToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                         if (!error) {
                                             NSLog(@"Success");
                                         } else {
                                             NSLog(@"Error: %@ %@", error, [error userInfo]);
                                         }
                                     }];
                                     
                                     
                                 }];
    
    
    return YES;
    

    
}
+ (BOOL) updateCurso: (CursoDTO *)curso{
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Curso"];
    
    [query getObjectInBackgroundWithId:curso.objectId
                                 block:^(PFObject *cursoToUpdate, NSError *error) {
                                     [cursoToUpdate setObject:curso.cantidadPalabras forKey:@"cantidadPalabras"];
                                     [cursoToUpdate setObject:curso.curso forKey:@"curso"];
                                     [cursoToUpdate setObject:curso.nombre forKey:@"nombre"];
                                     
                                     [cursoToUpdate saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                         if (!error) {
                                             NSLog(@"Success");
                                         } else {
                                             NSLog(@"Error: %@ %@", error, [error userInfo]);
                                         }
                                     }];
                                     
                                 }];
    
    
    
    return YES;

    
}
+ (void) selectCurso:(NSString *)cursoID{
    
     CursoDTO *cursoToSelect = [[CursoDTO alloc]init];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Curso"];
    [query getObjectInBackgroundWithId:cursoID
                                 block:^(PFObject *cursoFoundParse, NSError *error) {
                                     
                                     if (!error) {
                                         NSLog(@"Success");
                                         cursoToSelect.objectId = cursoFoundParse.objectId;
                                         cursoToSelect.nombre = [cursoFoundParse objectForKey:@"nombre"];
                                         cursoToSelect.cantidadPalabras =[cursoFoundParse objectForKey:@"cantidadPalabras"];
                                         cursoToSelect.curso= [cursoFoundParse objectForKey:@"curso"];

                                        
                                         
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"kCursoDidLoaded" object:cursoToSelect];
                                         
                                         
                                         
                                     } else {
                                         NSLog(@"Error: %@ %@", error, [error userInfo]);
                                     }
                                 }];
    
   

    
}
+ (void) selectCursoAll:(void (^) (NSArray *cursos))handler{
	
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
//											 (unsigned long)NULL), ^(void) {
//		[self getResultSetFromDB:docids];
//	});
	
    PFQuery *query = [PFQuery queryWithClassName:@"Curso"];
    
    __block NSMutableArray*resultados = [[NSMutableArray alloc]init];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *cursos, NSError *error) {
        if (!error) {
            
            for (int i=0; i<cursos.count; i++) {
                CursoDTO *objNuevo = [[CursoDTO alloc]init];
                PFObject *objArray = [cursos objectAtIndex:i];
                
                objNuevo.objectId = objArray.objectId;
                objNuevo.nombre = [objArray objectForKey:@"nombre"];
                objNuevo.cantidadPalabras =[objArray objectForKey:@"cantidadPalabras"];
                objNuevo.curso= [objArray objectForKey:@"curso"];
               
                [resultados addObject:objNuevo];
            }
			
			handler(resultados);
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];
  
}
@end

@implementation PalabraParse

+ (BOOL) insertPalabra:(PalabraDTO *)palabra{
    
    
    PFObject *palabraToInsert = [PFObject objectWithClassName:@"Palabra"];
   
    [palabraToInsert setObject:palabra.palabra forKey:@"palabra"];
    [palabraToInsert setObject:palabra.tipoPalabra forKey:@"tipoPalabra"];
     [palabraToInsert setObject:palabra.traduccion forKey:@"traduccion"];
    
    [palabraToInsert setObject:[PFObject objectWithoutDataWithClassName:@"Curso" objectId:palabra.curso ]forKey:@"curso"];
    
    
    [palabraToInsert saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Success");
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    return YES;

    
}
+ (BOOL) deletePalabra:(NSString *)palabraID{
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Palabra"];
    
    [query getObjectInBackgroundWithId:palabraID
                                 block:^(PFObject *palabraToDelete, NSError *error) {
                                     
                                     
                                     [palabraToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                         if (!error) {
                                             NSLog(@"Success");
                                         } else {
                                             NSLog(@"Error: %@ %@", error, [error userInfo]);
                                         }
                                     }];
                                     
                                     
                                 }];
    
    
    return YES;

    
}
+ (BOOL) updatePalabra: (PalabraDTO *)palabra{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Palabra"];
    
    [query getObjectInBackgroundWithId:palabra.objectId
                                 block:^(PFObject *palabraToUpdate, NSError *error) {
                                     
                                     [palabraToUpdate setObject:palabra.palabra forKey:@"palabra"];
                                     [palabraToUpdate setObject:palabra.tipoPalabra forKey:@"tipoPalabra"];
                                     [palabraToUpdate setObject:palabra.traduccion forKey:@"traduccion"];
                                     
                                     [palabraToUpdate setObject:[PFObject objectWithoutDataWithClassName:@"Curso" objectId:palabra.curso ]forKey:@"curso"];
                                     
                                     [palabraToUpdate saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                         if (!error) {
                                             NSLog(@"Success");
                                         } else {
                                             NSLog(@"Error: %@ %@", error, [error userInfo]);
                                         }
                                     }];
                                     
                                 }];
    
    
    
    return YES;

    
}
+ (void) selectPalabra:(NSString *)palabraID{
    
    
    PalabraDTO *palabraToSelect = [[PalabraDTO alloc]init];

    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Palabra"];
    [query getObjectInBackgroundWithId:palabraID
                                 block:^(PFObject *palabraFoundParse, NSError *error) {
                                     
                                     if (!error) {
                                         NSLog(@"Success");
                                         palabraToSelect.objectId = palabraFoundParse.objectId;
                                         // palabraToSelect.audio = [palabraFoundParse objectForKey:@"audio"];
                                         palabraToSelect.palabra =[palabraFoundParse objectForKey:@"palabra"];
                                         palabraToSelect.tipoPalabra =[palabraFoundParse objectForKey:@"tipoPalabra"];
                                         palabraToSelect.traduccion =[palabraFoundParse objectForKey:@"traduccion"];
                                         
                                         PFObject *curso = [palabraFoundParse objectForKey:@"curso"];
                                        
                                         palabraToSelect.curso= curso.objectId;
                                             
                                             

                                        
                                                                                  
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"kPalabraDidLoaded" object:palabraToSelect];
                                         
                                     } else {
                                         NSLog(@"Error: %@ %@", error, [error userInfo]);
                                     }
                                 }];
    
    

    

    
}
+ (void) selectPalabraAll:(void (^) (NSArray *palabras))handler{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Palabra"];
    
    __block NSMutableArray *resultados = [[NSMutableArray alloc]init];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *palabras, NSError *error) {
        if (!error) {
            PalabraDTO *objNuevo = [[PalabraDTO alloc]init];
            
            for (int i=0; i<palabras.count; i++) {
                
                PFObject *objArray = palabras[i];
                
                objNuevo.objectId = objArray.objectId;
                // palabraToSelect.audio = [palabraFoundParse objectForKey:@"audio"];
                objNuevo.palabra =[objArray objectForKey:@"palabra"];
                objNuevo.tipoPalabra =[objArray objectForKey:@"tipoPalabra"];
                objNuevo.traduccion =[objArray objectForKey:@"traduccion"];
                PFObject *curso = [objArray objectForKey:@"curso"];
                objNuevo.curso= curso.objectId;
                
                [resultados addObject:objNuevo];
            }
            handler(resultados);
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];

    

    
}
+ (void) selectPalabraAllByCursoID:(NSString *)cursoID completion:(void (^) (NSArray *palabrasDelCurso))handler{
    PFQuery *query = [PFQuery queryWithClassName:@"Palabra"];
    
    __block NSMutableArray *resultados = [[NSMutableArray alloc]init];
    
    [query whereKey:@"curso"
            equalTo:[PFObject objectWithoutDataWithClassName:@"Curso" objectId:cursoID]];

    
    [query findObjectsInBackgroundWithBlock:^(NSArray *palabras, NSError *error) {
        if (!error) {
            PalabraDTO *objNuevo = [[PalabraDTO alloc]init];
            
            for (int i=0; i<palabras.count; i++) {
                
                PFObject *objArray = palabras[i];
                
                objNuevo.objectId = objArray.objectId;
                // palabraToSelect.audio = [palabraFoundParse objectForKey:@"audio"];
                objNuevo.palabra =[objArray objectForKey:@"palabra"];
                objNuevo.tipoPalabra =[objArray objectForKey:@"tipoPalabra"];
                objNuevo.traduccion =[objArray objectForKey:@"traduccion"];
                PFObject *curso = [objArray objectForKey:@"curso"];
               
                objNuevo.curso= curso.objectId;
                    
                    
                    
               
                
                [resultados addObject:objNuevo];
            }
            
            NSLog(@"Success");
            handler(resultados);
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];
}


@end

@implementation PalabraAvanceParse

+ (BOOL) insertPalabraAvance:(PalabraAvanceDTO *)palabra completion:(void (^) (NSString *palabraAvanceId))handler{
    
    
    PFObject *palabraAvanceToInsert = [PFObject objectWithClassName:@"PalabraAvance"];
    
    [palabraAvanceToInsert setObject:palabra.avance forKey:@"avance"];
    [palabraAvanceToInsert setObject:palabra.estado forKey:@"estado"];
    [palabraAvanceToInsert setObject:palabra.prioridad forKey:@"prioridad"];
    [palabraAvanceToInsert setObject:palabra.ultimaFechaRepaso forKey:@"ultimaFechaRepaso"];
    
    [palabraAvanceToInsert setObject:[PFObject objectWithoutDataWithClassName:@"Usuario" objectId:palabra.usuario ]forKey:@"usuario"];
    
    [palabraAvanceToInsert setObject:[PFObject objectWithoutDataWithClassName:@"Palabra" objectId:palabra.palabra ]forKey:@"palabra"];
    
    
    [palabraAvanceToInsert saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Success");
            handler([palabraAvanceToInsert objectId]);
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            handler(nil);
        }
    }];
    
    return YES;
    
    
}
+ (BOOL) deletePalabraAvance:(NSString *)palabraAvanceID{
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"PalabraAvance"];
    
    [query getObjectInBackgroundWithId:palabraAvanceID
                                 block:^(PFObject *palabraToDelete, NSError *error) {
                                     
                                     
                                     [palabraToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                         if (!error) {
                                             NSLog(@"Success");
                                         } else {
                                             NSLog(@"Error: %@ %@", error, [error userInfo]);
                                         }
                                     }];
                                     
                                     
                                 }];
    
    
    return YES;
    
    
}
+ (BOOL) updatePalabraAvance:(PalabraAvanceDTO *)palabraAvance{
    
    PFQuery *query = [PFQuery queryWithClassName:@"PalabraAvance"];
    
    [query getObjectInBackgroundWithId:palabraAvance.objectId
                                 block:^(PFObject *palabraToUpdate, NSError *error) {
                                     
                                     [palabraToUpdate setObject:palabraAvance.avance forKey:@"avance"];
                                     [palabraToUpdate setObject:palabraAvance.estado forKey:@"estado"];
                                     [palabraToUpdate setObject:palabraAvance.prioridad forKey:@"prioridad"];
                                     [palabraToUpdate setObject:palabraAvance.ultimaFechaRepaso forKey:@"ultimaFechaRepaso"];
                                     
                                     [palabraToUpdate setObject:[PFObject objectWithoutDataWithClassName:@"Usuario" objectId:palabraAvance.usuario ]forKey:@"usuario"];
                                     
                                     [palabraToUpdate setObject:[PFObject objectWithoutDataWithClassName:@"Palabra" objectId:palabraAvance.palabra ]forKey:@"palabra"];

                                     
                                     [palabraToUpdate saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                         if (!error) {
                                             NSLog(@"Success");
                                         } else {
                                             NSLog(@"Error: %@ %@", error, [error userInfo]);
                                         }
                                     }];
                                     
                                 }];
    
    
    
    return YES;
    
    
}
+ (void) selectPalabraAvance:(NSString *)palabraAvanceID{
    
    
    PalabraAvanceDTO *palabraToSelect = [[PalabraAvanceDTO alloc]init];
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"PalabraAvance"];
    [query getObjectInBackgroundWithId:palabraAvanceID
                                 block:^(PFObject *palabraFoundParse, NSError *error) {
                                     
                                     if (!error) {
                                         NSLog(@"Success");
                                         palabraToSelect.objectId = palabraFoundParse.objectId;
                                         // palabraToSelect.audio = [palabraFoundParse objectForKey:@"audio"];
                                         palabraToSelect.avance =[palabraFoundParse objectForKey:@"avance"];
                                         palabraToSelect.prioridad =[palabraFoundParse objectForKey:@"prioridad"];
                                         palabraToSelect.estado =[palabraFoundParse objectForKey:@"estado"];
                                         palabraToSelect.ultimaFechaRepaso =[palabraFoundParse objectForKey:@"ultimaFechaRepaso"];
										 palabraToSelect.ultimaSincronizacion = [palabraFoundParse objectForKey:@"updatedAt"];
                                         
                                         PFObject *palabra = [palabraFoundParse objectForKey:@"palabra"];
                                         PFObject *usuario = [palabraFoundParse objectForKey:@"usuario"];
                                         
                                         palabraToSelect.palabra= palabra.objectId;
                                         palabraToSelect.usuario= usuario.objectId;
                                         
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"kPalabraAvanceDidLoaded" object:palabraToSelect];
                                         
                                     } else {
                                         NSLog(@"Error: %@ %@", error, [error userInfo]);
                                     }
                                 }];
}
+ (void) selectPalabraAvanceAll{
    
    PFQuery *query = [PFQuery queryWithClassName:@"PalabraAvance"];
    
    __block NSMutableArray *resultados = [[NSMutableArray alloc]init];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *palabras, NSError *error) {
        if (!error) {
            PalabraAvanceDTO *objNuevo = [[PalabraAvanceDTO alloc]init];
            
            for (int i=0; i<palabras.count; i++) {
                
                PFObject *objArray = palabras[i];
                
                objNuevo.objectId = objArray.objectId;
                objNuevo.avance =[objArray objectForKey:@"avance"];
                objNuevo.prioridad =[objArray objectForKey:@"prioridad"];
                objNuevo.estado =[objArray objectForKey:@"estado"];
                objNuevo.ultimaFechaRepaso =[objArray objectForKey:@"ultimaFechaRepaso"];
				objNuevo.ultimaSincronizacion = [objArray objectForKey:@"updatedAt"];
				
                
                PFObject *palabra = [objArray objectForKey:@"palabra"];
                PFObject *usuario = [objArray objectForKey:@"usuario"];
                
                objNuevo.palabra= palabra.objectId;
                objNuevo.usuario= usuario.objectId;
                
                [resultados addObject:objNuevo];
            }
            
            NSLog(@"Success");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kListPalabraAvanceDidLoaded" object:resultados];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];
    
    
    
    
}
+ (void) selectPalabraAvanceAllByUserID:(NSString *)userID{
    PFQuery *query = [PFQuery queryWithClassName:@"PalabraAvance"];
    
    __block NSMutableArray *resultados = [[NSMutableArray alloc]init];
    
    [query whereKey:@"usuario"
            equalTo:[PFObject objectWithoutDataWithClassName:@"Usuario" objectId:userID]];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *palabras, NSError *error) {
        if (!error) {
            PalabraAvanceDTO *objNuevo = [[PalabraAvanceDTO alloc]init];
            
            for (int i=0; i<palabras.count; i++) {
                
                PFObject *objArray = palabras[i];
                
                objNuevo.objectId = objArray.objectId;
                objNuevo.avance =[objArray objectForKey:@"avance"];
                objNuevo.prioridad =[objArray objectForKey:@"prioridad"];
                objNuevo.estado =[objArray objectForKey:@"estado"];
                objNuevo.ultimaFechaRepaso =[objArray objectForKey:@"ultimaFechaRepaso"];
				objNuevo.ultimaSincronizacion = [objArray objectForKey:@"updatedAt"];
                
                PFObject *palabra = [objArray objectForKey:@"palabra"];
                PFObject *usuario = [objArray objectForKey:@"usuario"];
                
                objNuevo.palabra= palabra.objectId;
                objNuevo.usuario= usuario.objectId;
                
                [resultados addObject:objNuevo];
            }
            
            NSLog(@"Success");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kListPalabraAvanceByUserIDDidLoaded" object:resultados];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];
}
+ (void) selectPalabraAvanceByUserID:(NSString *)userID palabraID:(NSString *)palabraID completion:(void (^) (NSArray *palabraAvances))handler
{
    PFQuery *query = [PFQuery queryWithClassName:@"PalabraAvance"];
    
    __block NSMutableArray *resultados = [[NSMutableArray alloc]init];
    
    [query whereKey:@"usuario"
            equalTo:[PFObject objectWithoutDataWithClassName:@"Usuario" objectId:userID]];
    [query whereKey:@"palabra"
            equalTo:[PFObject objectWithoutDataWithClassName:@"Palabra" objectId:palabraID]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *palabras, NSError *error) {
        if (!error) {
            PalabraAvanceDTO *objNuevo = [[PalabraAvanceDTO alloc]init];
            
            for (int i=0; i<palabras.count; i++) {
                
                PFObject *objArray = palabras[i];
                
                objNuevo.objectId = objArray.objectId;
                objNuevo.avance =[objArray objectForKey:@"avance"];
                objNuevo.prioridad =[objArray objectForKey:@"prioridad"];
                objNuevo.estado =[objArray objectForKey:@"estado"];
                objNuevo.ultimaFechaRepaso =[objArray objectForKey:@"ultimaFechaRepaso"];
				objNuevo.ultimaSincronizacion = [objArray objectForKey:@"updatedAt"];
                
                PFObject *palabra = [objArray objectForKey:@"palabra"];
                PFObject *usuario = [objArray objectForKey:@"usuario"];
                
                objNuevo.palabra= palabra.objectId;
                objNuevo.usuario= usuario.objectId;
                
                [resultados addObject:objNuevo];
            }
            
            NSLog(@"Success");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kListPalabraAvanceByUserIDPalabraIDDidLoaded" object:resultados];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];
}

@end

@implementation CursoAvanceParse

+ (BOOL) insertCursoAvance:(CursoAvanceDTO *)cursoAvance completion:(void (^) (NSString *cursoAvanceId))handler{
    
    
    PFObject *cursoAvanceToInsert = [PFObject objectWithClassName:@"CursoAvance"];
    
    [cursoAvanceToInsert setObject:cursoAvance.avance forKey:@"avance"];
    [cursoAvanceToInsert setObject:cursoAvance.palabrasComenzadas forKey:@"palabrasComenzadas"];
    [cursoAvanceToInsert setObject:cursoAvance.palabrasCompletas forKey:@"palabrasCompletas"];
    [cursoAvanceToInsert setObject:cursoAvance.tiempoEstudiado forKey:@"tiempoEstudiado"];
    
    [cursoAvanceToInsert setObject:[PFObject objectWithoutDataWithClassName:@"Usuario" objectId:cursoAvance.usuario ]forKey:@"usuario"];
    
    [cursoAvanceToInsert setObject:[PFObject objectWithoutDataWithClassName:@"Curso" objectId:cursoAvance.curso ]forKey:@"curso"];
    
    
    [cursoAvanceToInsert saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Success");
            handler([cursoAvanceToInsert objectId]);
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            handler(nil);
        }
    }];
    
    return YES;
    
    
}
+ (BOOL) deleteCursoAvance:(NSString *)cursoAvanceID{
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"CursoAvance"];
    
    [query getObjectInBackgroundWithId:cursoAvanceID
                                 block:^(PFObject *palabraToDelete, NSError *error) {
                                     
                                     
                                     [palabraToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                         if (!error) {
                                             NSLog(@"Success");
                                         } else {
                                             NSLog(@"Error: %@ %@", error, [error userInfo]);
                                         }
                                     }];
                                     
                                     
                                 }];
    
    
    return YES;
    
    
}
+ (BOOL) updateCursoAvance:(CursoAvanceDTO *)cursoAvance{
    
    PFQuery *query = [PFQuery queryWithClassName:@"CursoAvance"];
    
    [query getObjectInBackgroundWithId:cursoAvance.objectId
                                 block:^(PFObject *cursoToUpdate, NSError *error) {
                                     
                                     [cursoToUpdate setObject:cursoAvance.avance forKey:@"avance"];
                                     [cursoToUpdate setObject:cursoAvance.palabrasComenzadas forKey:@"palabrasComenzadas"];
                                     [cursoToUpdate setObject:cursoAvance.palabrasCompletas forKey:@"palabrasCompletas"];
                                     [cursoToUpdate setObject:cursoAvance.tiempoEstudiado forKey:@"tiempoEstudiado"];
                                     
                                     [cursoToUpdate setObject:[PFObject objectWithoutDataWithClassName:@"Usuario" objectId:cursoAvance.usuario ]forKey:@"usuario"];
                                     
                                     [cursoToUpdate setObject:[PFObject objectWithoutDataWithClassName:@"Curso" objectId:cursoAvance.curso ]forKey:@"curso"];
                                     
                                     
                                     [cursoToUpdate saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                         if (!error) {
                                             NSLog(@"Success");
                                         } else {
                                             NSLog(@"Error: %@ %@", error, [error userInfo]);
                                         }
                                     }];
                                     
                                 }];
    
    
    
    return YES;
    
    
}
+ (void) selectCursoAvance:(NSString *)cursoAvanceID{
    
    
    CursoAvanceDTO *cursoToSelect = [[CursoAvanceDTO alloc]init];
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"CursoAvance"];
    [query getObjectInBackgroundWithId:cursoAvanceID
                                 block:^(PFObject *cursoFoundParse, NSError *error) {
                                     
                                     if (!error) {
                                         NSLog(@"Success");
                                         cursoToSelect.objectId = cursoFoundParse.objectId;
                                         cursoToSelect.avance =[cursoFoundParse objectForKey:@"avance"];
                                         cursoToSelect.palabrasComenzadas =[cursoFoundParse objectForKey:@"palabrasComenzadas"];
                                         cursoToSelect.palabrasCompletas =[cursoFoundParse objectForKey:@"palabrasCompletas"];
                                         cursoToSelect.tiempoEstudiado =[cursoFoundParse objectForKey:@"tiempoEstudiado"];
                                         cursoToSelect.ultimaSincronizacion = [cursoFoundParse objectForKey:@"updatedAt"];
                                         PFObject *curso = [cursoFoundParse objectForKey:@"curso"];
                                         PFObject *usuario = [cursoFoundParse objectForKey:@"usuario"];
                                         
                                         cursoToSelect.curso= curso.objectId;
                                         cursoToSelect.usuario= usuario.objectId;
                                         
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"kCursoAvanceDidLoaded" object:cursoToSelect];
                                         
                                     } else {
                                         NSLog(@"Error: %@ %@", error, [error userInfo]);
                                     }
                                 }];
}
+ (void) selectCursoAvanceAll:(void (^) (NSArray *cursoAvances))handler{
    
    PFQuery *query = [PFQuery queryWithClassName:@"CursoAvance"];
    
    __block NSMutableArray *resultados = [[NSMutableArray alloc]init];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *palabras, NSError *error) {
        if (!error) {
            CursoAvanceDTO *objNuevo = [[CursoAvanceDTO alloc]init];
            
            for (int i=0; i<palabras.count; i++) {
                
                PFObject *objArray = palabras[i];
                
                objNuevo.objectId = objArray.objectId;
                objNuevo.avance =[objArray objectForKey:@"avance"];
                objNuevo.palabrasComenzadas =[objArray objectForKey:@"palabrasComenzadas"];
                objNuevo.palabrasCompletas =[objArray objectForKey:@"palabrasCompletas"];
                objNuevo.tiempoEstudiado =[objArray objectForKey:@"tiempoEstudiado"];
                objNuevo.ultimaSincronizacion = [objArray objectForKey:@"updatedAt"];
				
                PFObject *curso = [objArray objectForKey:@"curso"];
                PFObject *usuario = [objArray objectForKey:@"usuario"];
                
                objNuevo.curso= curso.objectId;
                objNuevo.usuario= usuario.objectId;
                
                [resultados addObject:objNuevo];
            }
            
            handler(resultados);
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];
    
    
    
    
}
+ (void) selectCursoAvanceAllByUserID:(NSString *)userID completion:(void (^) (NSArray *cursoAvances))handler{
    PFQuery *query = [PFQuery queryWithClassName:@"CursoAvance"];
    
    __block NSMutableArray *resultados = [[NSMutableArray alloc]init];
    
    [query whereKey:@"usuario"
            equalTo:[PFObject objectWithoutDataWithClassName:@"Usuario" objectId:userID]];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *palabras, NSError *error) {
        if (!error) {
            CursoAvanceDTO *objNuevo = [[CursoAvanceDTO alloc]init];
            
            for (int i=0; i<palabras.count; i++) {
                
                PFObject *objArray = palabras[i];
                
                objNuevo.objectId = objArray.objectId;
                objNuevo.avance =[objArray objectForKey:@"avance"];
                objNuevo.palabrasComenzadas =[objArray objectForKey:@"palabrasComenzadas"];
                objNuevo.palabrasCompletas =[objArray objectForKey:@"palabrasCompletas"];
                objNuevo.tiempoEstudiado =[objArray objectForKey:@"tiempoEstudiado"];
                objNuevo.ultimaSincronizacion = [objArray objectForKey:@"updatedAt"];
				
                PFObject *curso = [objArray objectForKey:@"curso"];
                PFObject *usuario = [objArray objectForKey:@"usuario"];
                
                objNuevo.curso= curso.objectId;
                objNuevo.usuario= usuario.objectId;
                
                [resultados addObject:objNuevo];
            }
            
            NSLog(@"Success");
            handler(resultados);
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];
}
+ (void) selectCursoAvanceByUserID:(NSString *)userID cursoID:(NSString *)cursoID completion:(void (^) (NSArray *cursoAvances))handler
{
    PFQuery *query = [PFQuery queryWithClassName:@"CursoAvance"];
    
    __block NSMutableArray *resultados = [[NSMutableArray alloc]init];
    
    [query whereKey:@"usuario"
            equalTo:[PFObject objectWithoutDataWithClassName:@"Usuario" objectId:userID]];
    [query whereKey:@"curso"
            equalTo:[PFObject objectWithoutDataWithClassName:@"Curso" objectId:cursoID]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *palabras, NSError *error) {
        if (!error) {
            CursoAvanceDTO *objNuevo = [[CursoAvanceDTO alloc]init];
            
            for (int i=0; i<palabras.count; i++) {
                
                PFObject *objArray = palabras[i];
                
                objNuevo.objectId = objArray.objectId;
                objNuevo.avance =[objArray objectForKey:@"avance"];
                objNuevo.palabrasComenzadas =[objArray objectForKey:@"palabrasComenzadas"];
                objNuevo.palabrasCompletas =[objArray objectForKey:@"palabrasCompletas"];
                objNuevo.tiempoEstudiado =[objArray objectForKey:@"tiempoEstudiado"];
                objNuevo.ultimaSincronizacion = [objArray objectForKey:@"updatedAt"];
				
                PFObject *curso = [objArray objectForKey:@"curso"];
                PFObject *usuario = [objArray objectForKey:@"usuario"];
                
                objNuevo.curso= curso.objectId;
                objNuevo.usuario= usuario.objectId;
                
                [resultados addObject:objNuevo];
            }
            
            NSLog(@"Success");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kListCursoAvanceByUserIDCursoIDDidLoaded" object:resultados];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];
}

@end

@implementation OracionParse

+ (BOOL) insertOracion:(OracionDTO *)oracion{
    
    PFObject *oracionToInsert = [PFObject objectWithClassName:@"Oracion"];
    
    //[oracionToInsert setObject:oracion.audio forKey:@"audio"];
    [oracionToInsert setObject:oracion.oracion forKey:@"oracion"];
    [oracionToInsert setObject:oracion.traduccion forKey:@"traduccion"];
   
    
    [oracionToInsert setObject:[PFObject objectWithoutDataWithClassName:@"Palabra" objectId:oracion.palabra ]forKey:@"palabra"];
    
    
    [oracionToInsert saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Success");
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    return YES;
    
}
+ (BOOL) deleteOracion:(NSString *)oracionID{
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Oracion"];
    
    [query getObjectInBackgroundWithId:oracionID
                                 block:^(PFObject *oracionToDelete, NSError *error) {
                                     
                                     
                                     [oracionToDelete deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                         if (!error) {
                                             NSLog(@"Success");
                                         } else {
                                             NSLog(@"Error: %@ %@", error, [error userInfo]);
                                         }
                                     }];
                                     
                                     
                                 }];
    
    
    return YES;

    
}
+ (BOOL) updateOracion: (OracionDTO *)oracion{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Oracion"];
    
    [query getObjectInBackgroundWithId:oracion.objectId
                                 block:^(PFObject *oracionToUpdate, NSError *error) {
                                     
                                     //[oracionToUpdate setObject:oracion.audio forKey:@"audio"];
                                     [oracionToUpdate setObject:oracion.traduccion forKey:@"traduccion"];
                                     [oracionToUpdate setObject:oracion.oracion forKey:@"oracion"];
                                     
                                     [oracionToUpdate setObject:[PFObject objectWithoutDataWithClassName:@"Palabra" objectId:oracion.palabra ]forKey:@"palabra"];
                                     
                                     [oracionToUpdate saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                         if (!error) {
                                             NSLog(@"Success");
                                         } else {
                                             NSLog(@"Error: %@ %@", error, [error userInfo]);
                                         }
                                     }];
                                     
                                 }];
    
    
    
    return YES;
    

    
}
+ (void) selectOracion:(NSString *)oracionID{
    
    OracionDTO *oracionToSelect = [[OracionDTO alloc]init];
    

        
    PFQuery *query = [PFQuery queryWithClassName:@"Oracion"];
    [query getObjectInBackgroundWithId:oracionID
                                 block:^(PFObject *oracionFoundParse, NSError *error) {
                                     
                                     if (!error) {
                                         NSLog(@"Success");
                                         oracionToSelect.objectId = oracionFoundParse.objectId;
                                         // oracionToSelect.audio = [oracionFoundParse objectForKey:@"audio"];
                                         oracionToSelect.traduccion = [oracionFoundParse objectForKey:@"traduccion"];
                                         oracionToSelect.oracion =[oracionFoundParse objectForKey:@"oracion"];
                                     
                                         PFObject *palabra = [oracionFoundParse objectForKey:@"palabra"];
                                         
                                        oracionToSelect.palabra= palabra.objectId;
                                        
                                         
                                         
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"kOracionDidLoaded" object:oracionToSelect];
                                         
                                         
                                     } else {
                                         NSLog(@"Error: %@ %@", error, [error userInfo]);
                                     }
                                 }];
    
    

    
}
+ (void) selectOracionAll{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Oracion"];
    
    __block NSMutableArray *resultados = [[NSMutableArray alloc]init];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *oraciones, NSError *error) {
        if (!error) {
            OracionDTO *objNuevo = [[OracionDTO alloc]init];
            
            for (int i=0; i<oraciones.count; i++) {
                
                PFObject *objArray = oraciones[i];
                
                objNuevo.objectId = objArray.objectId;
                // oracionToSelect.audio = [oracionFoundParse objectForKey:@"audio"];
                objNuevo.traduccion = [objArray objectForKey:@"traduccion"];
                objNuevo.oracion =[objArray objectForKey:@"oracion"];
                PFObject *palabra = [objArray objectForKey:@"palabra"];
               
                objNuevo.palabra= palabra.objectId;
               
                

                
                [resultados addObject:objNuevo];
            }
            

            NSLog(@"Success");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kListOracionDidLoaded" object:resultados];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];
    
    
    
}
+ (void) selectOracionAllByPalabraID:(NSString *)palabraID completion:(void (^) (NSArray *oraciones))handler{
    PFQuery *query = [PFQuery queryWithClassName:@"Oracion"];
    
    __block NSMutableArray *resultados = [[NSMutableArray alloc]init];
    
    [query whereKey:@"palabra"
            equalTo:[PFObject objectWithoutDataWithClassName:@"Palabra" objectId:palabraID]];

    
    [query findObjectsInBackgroundWithBlock:^(NSArray *oraciones, NSError *error) {
        if (!error) {
            OracionDTO *objNuevo = [[OracionDTO alloc]init];
            
            for (int i=0; i<oraciones.count; i++) {
                
                PFObject *objArray = oraciones[i];
                
                objNuevo.objectId = objArray.objectId;
                // oracionToSelect.audio = [oracionFoundParse objectForKey:@"audio"];
                objNuevo.traduccion = [objArray objectForKey:@"traduccion"];
                objNuevo.oracion =[objArray objectForKey:@"oracion"];
                PFObject *palabra = [objArray objectForKey:@"palabra"];
                
                objNuevo.palabra= palabra.objectId;
                
                
                
                
                [resultados addObject:objNuevo];
            }
            
            
            NSLog(@"Success");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kListOracionByIDPalabraDidLoaded" object:resultados];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];

}

@end


