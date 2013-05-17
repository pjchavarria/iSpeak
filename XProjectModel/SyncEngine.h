//
//  SyncEngine.h
//  iSpeak
//
//  Created by Paul on 16/05/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Usuario,Curso,Palabra;
@interface SyncEngine : NSObject

+ (SyncEngine *)sharedEngine;
- (void)syncUser:(UsuarioDTO*)data;
- (void)createCursoAvance:(Usuario *)usuario Curso:(Curso *)curso;
- (void)createPalabraAvance:(Usuario *)usuario Palabra:(Palabra *)palabra;

- (void)syncCursos:(void(^)())handler;
- (void)syncCursoAvance:(Usuario *)usuario completion:(void(^)())handler;
- (void)syncPalabras:(Curso*)curso completion:(void(^)())handler;
- (void)syncOraciones:(Palabra*)palabra completion:(void(^)())handler;
- (void)syncPalabraAvanceConUsuario:(Usuario *)usuario Palabra:(Palabra*)palabra completion:(void(^)())handler;

- (void)seAcabaDeLoguear:(Usuario *)usuario completion:(void(^)())handler;
- (void)iniciarCurso:(Curso *)curso;
- (void)iniciarRepaso:(Curso *)curso;
- (void)finalizarLeccion:(Curso *)curso;
- (void)elInternetRegreso;


@end
