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

+ (BOOL)insertUsuario:(UsuarioDTO *)user{
    
    
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
+(BOOL) updateUsuario: (UsuarioDTO *)user{
    
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

+ (void) validateUsuario:(NSString *)username Password:(NSString *)password
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Usuario"];
    [query whereKey:@"username" equalTo:username];
    [query whereKey:@"password" equalTo:password];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                                     
                                     if (!error) {
                                         NSLog(@"Success");
                                         if(array.count > 0 && array.count < 2)
                                         {
                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidEnter" object:nil];
                                         }
                                         else
                                         {
                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidNotEnter" object:nil];
                                         }
                                     } else {
                                         NSLog(@"Error: %@ %@", error, [error userInfo]);
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidNotEnter" object:nil];
                                     }
                                 }];
    
}

@end

@implementation CursoParse
+ (BOOL)insertCurso:(CursoDTO *)curso{
    
    PFObject *cursoToInsert = [PFObject objectWithClassName:@"Curso"];
    
    [cursoToInsert setObject:curso.avance forKey:@"avance"];
    [cursoToInsert setObject:curso.cantidadPalabras forKey:@"cantidadPalabras"];
    [cursoToInsert setObject:curso.curso forKey:@"curso"];
    [cursoToInsert setObject:curso.nombre forKey:@"nombre"];
    [cursoToInsert setObject:curso.palabrasCompletas forKey:@"palabrasCompletas"];
    [cursoToInsert setObject:curso.tiempoEstudiando forKey:@"tiempoEstudiando"];
    
    [cursoToInsert setObject:[PFObject objectWithoutDataWithClassName:@"Nivel" objectId:curso.nivel ]forKey:@"nivel"];
    
    
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
+(BOOL) updateCurso: (CursoDTO *)curso{
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Curso"];
    
    [query getObjectInBackgroundWithId:curso.objectId
                                 block:^(PFObject *cursoToUpdate, NSError *error) {
                                     
                                     [cursoToUpdate setObject:curso.avance forKey:@"avance"];
                                     [cursoToUpdate setObject:curso.cantidadPalabras forKey:@"cantidadPalabras"];
                                     [cursoToUpdate setObject:curso.curso forKey:@"curso"];
                                     [cursoToUpdate setObject:curso.nombre forKey:@"nombre"];
                                     [cursoToUpdate setObject:curso.palabrasCompletas forKey:@"palabrasCompletas"];
                                     [cursoToUpdate setObject:curso.tiempoEstudiando forKey:@"tiempoEstudiando"];
                                     
                                     [cursoToUpdate setObject:[PFObject objectWithoutDataWithClassName:@"Nivel" objectId:curso.nivel]forKey:@"nivel"];
                                     
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
                                         cursoToSelect.avance = [cursoFoundParse objectForKey:@"avance"];
                                         cursoToSelect.cantidadPalabras =[cursoFoundParse objectForKey:@"cantidadPalabras"];
                                         cursoToSelect.curso= [cursoFoundParse objectForKey:@"curso"];
                                         cursoToSelect.palabrasCompletas =[cursoFoundParse objectForKey:@"palabrasCompletas"];
                                         cursoToSelect.tiempoEstudiando =[cursoFoundParse objectForKey:@"tiempoEstudiando"];
                                         
                                         PFObject *nivel = [cursoFoundParse objectForKey:@"nivel"];
                                         
                                         cursoToSelect.nivel= nivel.objectId;
                                        
                                         
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"kCursoDidLoaded" object:cursoToSelect];
                                         
                                         
                                         
                                     } else {
                                         NSLog(@"Error: %@ %@", error, [error userInfo]);
                                     }
                                 }];
    
   

    
}
+ (void) selectCursoAll{
    PFQuery *query = [PFQuery queryWithClassName:@"Curso"];
    
    __block NSMutableArray*resultados = [[NSMutableArray alloc]init];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *cursos, NSError *error) {
        if (!error) {
            
            
            for (int i=0; i<cursos.count; i++) {
                CursoDTO *objNuevo = [[CursoDTO alloc]init];
                PFObject *objArray = [cursos objectAtIndex:i];
                
                objNuevo.objectId = objArray.objectId;
                objNuevo.nombre = [objArray objectForKey:@"nombre"];
                objNuevo.avance = [objArray objectForKey:@"avance"];
                objNuevo.cantidadPalabras =[objArray objectForKey:@"cantidadPalabras"];
                objNuevo.curso= [objArray objectForKey:@"curso"];
                objNuevo.palabrasCompletas =[objArray objectForKey:@"palabrasCompletas"];
                objNuevo.tiempoEstudiando =[objArray objectForKey:@"tiempoEstudiando"];
                
                PFObject *nivel = [objArray objectForKey:@"nivel"];
               
                    objNuevo.nivel= nivel.objectId;
               
                [resultados addObject:objNuevo];
            }
            NSLog(@"Success");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kListCursoDidLoaded" object:resultados];

            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];
  
}

+ (void) selectCursoAllByNivelID:(NSString *)nivelID{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Curso"];
    
    __block NSMutableArray*resultados = [[NSMutableArray alloc]init];
    
    [query whereKey:@"nivel"
            equalTo:[PFObject objectWithoutDataWithClassName:@"Nivel" objectId:nivelID]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *cursos, NSError *error) {
        if (!error) {
            CursoDTO *objNuevo = [[CursoDTO alloc]init];
            
            for (int i=0; i<cursos.count; i++) {
                
                PFObject *objArray = cursos[i];
                
                objNuevo.objectId = objArray.objectId;
                objNuevo.nombre = [objArray objectForKey:@"nombre"];
                objNuevo.avance = [objArray objectForKey:@"avance"];
                objNuevo.cantidadPalabras =[objArray objectForKey:@"cantidadPalabras"];
                objNuevo.curso= [objArray objectForKey:@"curso"];
                objNuevo.palabrasCompletas =[objArray objectForKey:@"palabrasCompletas"];
                objNuevo.tiempoEstudiando =[objArray objectForKey:@"tiempoEstudiando"];
                
               
                PFObject *nivel = [objArray objectForKey:@"nivel"];
                
                objNuevo.nivel= nivel.objectId;
                   
                   
               

                
                 [resultados addObject:objNuevo];
            }
            NSLog(@"Success");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kListCursoByNivelDidLoaded" object:resultados];
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];

    
}



@end

@implementation PalabraParse

+ (BOOL)insertPalabra:(PalabraDTO *)palabra{
    
    
    PFObject *palabraToInsert = [PFObject objectWithClassName:@"Palabra"];
   
    [palabraToInsert setObject:palabra.avance forKey:@"avance"];
    [palabraToInsert setObject:palabra.estado forKey:@"estado"];
    [palabraToInsert setObject:palabra.palabra forKey:@"palabra"];
    [palabraToInsert setObject:palabra.prioridad forKey:@"prioridad"];
    [palabraToInsert setObject:palabra.tipoPalabra forKey:@"tipoPalabra"];
     [palabraToInsert setObject:palabra.traduccion forKey:@"traduccion"];
     [palabraToInsert setObject:palabra.ultimaFechaRepaso forKey:@"ultimaFechaRepaso"];
    
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
+(BOOL) updatePalabra: (PalabraDTO *)palabra{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Palabra"];
    
    [query getObjectInBackgroundWithId:palabra.objectId
                                 block:^(PFObject *palabraToUpdate, NSError *error) {
                                     
                                    [palabraToUpdate setObject:palabra.estado forKey:@"estado"];
                                     [palabraToUpdate setObject:palabra.avance forKey:@"avance"];
                                     [palabraToUpdate setObject:palabra.palabra forKey:@"palabra"];
                                     [palabraToUpdate setObject:palabra.prioridad forKey:@"prioridad"];
                                     [palabraToUpdate setObject:palabra.tipoPalabra forKey:@"tipoPalabra"];
                                     [palabraToUpdate setObject:palabra.traduccion forKey:@"traduccion"];
                                     [palabraToUpdate setObject:palabra.ultimaFechaRepaso forKey:@"ultimaFechaRepaso"];
                                     
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
                                         palabraToSelect.avance = [palabraFoundParse objectForKey:@"avance"];
                                         palabraToSelect.estado =[palabraFoundParse objectForKey:@"estado"];
                                         palabraToSelect.palabra =[palabraFoundParse objectForKey:@"palabra"];
                                         palabraToSelect.prioridad= [palabraFoundParse objectForKey:@"prioridad"];
                                         palabraToSelect.tipoPalabra =[palabraFoundParse objectForKey:@"tipoPalabra"];
                                         palabraToSelect.traduccion =[palabraFoundParse objectForKey:@"traduccion"];
                                         palabraToSelect.ultimaFechaRepaso =[palabraFoundParse objectForKey:@"ultimaFechaRepaso"];
                                         
                                         PFObject *curso = [palabraFoundParse objectForKey:@"curso"];
                                        
                                         palabraToSelect.curso= curso.objectId;
                                             
                                             

                                        
                                                                                  
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"kPalabraDidLoaded" object:palabraToSelect];
                                         
                                     } else {
                                         NSLog(@"Error: %@ %@", error, [error userInfo]);
                                     }
                                 }];
    
    

    

    
}
+ (void) selectPalabraAll{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Palabra"];
    
    __block NSMutableArray *resultados = [[NSMutableArray alloc]init];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *palabras, NSError *error) {
        if (!error) {
            PalabraDTO *objNuevo = [[PalabraDTO alloc]init];
            
            for (int i=0; i<palabras.count; i++) {
                
                PFObject *objArray = palabras[i];
                
                objNuevo.objectId = objArray.objectId;
                // palabraToSelect.audio = [palabraFoundParse objectForKey:@"audio"];
                objNuevo.avance = [objArray objectForKey:@"avance"];
                objNuevo.estado =[objArray objectForKey:@"estado"];
                objNuevo.palabra =[objArray objectForKey:@"palabra"];
                objNuevo.prioridad= [objArray objectForKey:@"prioridad"];
                objNuevo.tipoPalabra =[objArray objectForKey:@"tipoPalabra"];
                objNuevo.traduccion =[objArray objectForKey:@"traduccion"];
                objNuevo.ultimaFechaRepaso =[objArray objectForKey:@"ultimaFechaRepaso"];
                PFObject *curso = [objArray objectForKey:@"curso"];
                objNuevo.curso= curso.objectId;
                    
                    
                    
             
                
                [resultados addObject:objNuevo];
            }

            NSLog(@"Success");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kListPalabraDidLoaded" object:resultados];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];

    

    
}
+ (void) selectPalabraAllByCursoID:(NSString *)cursoID{
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
                objNuevo.avance = [objArray objectForKey:@"avance"];
                objNuevo.estado =[objArray objectForKey:@"estado"];
                objNuevo.palabra =[objArray objectForKey:@"palabra"];
                objNuevo.prioridad= [objArray objectForKey:@"prioridad"];
                objNuevo.tipoPalabra =[objArray objectForKey:@"tipoPalabra"];
                objNuevo.traduccion =[objArray objectForKey:@"traduccion"];
                objNuevo.ultimaFechaRepaso =[objArray objectForKey:@"ultimaFechaRepaso"];
                PFObject *curso = [objArray objectForKey:@"curso"];
               
                objNuevo.curso= curso.objectId;
                    
                    
                    
               
                
                [resultados addObject:objNuevo];
            }
            
            NSLog(@"Success");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kListPalabraByCursoIDDidLoaded" object:resultados];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];
}


@end

@implementation OracionParse

+ (BOOL)insertOracion:(OracionDTO *)oracion{
    
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
+(BOOL) updateOracion: (OracionDTO *)oracion{
    
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
+(void) selectOracionAllByPalabraID:(NSString *)palabraID{
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


