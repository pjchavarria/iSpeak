//
//  SyncEngine.h
//  iSpeak
//
//  Created by Paul on 16/05/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Usuario,Curso;
@interface SyncEngine : NSObject

+ (SyncEngine *)sharedEngine;
- (void)syncUser:(UsuarioDTO*)data;
- (void)createCursoAvance:(Usuario *)usuario;
- (void)createPalabraAvance:(Usuario *)usuario;

- (void)syncCursos:(void(^)())handler;
- (void)syncCursosAvance:(Usuario *)usuario completion:(void(^)())handler;
- (void)syncPalabras:(CursoDTO*)curso;
- (void)syncOraciones:(CursoDTO*)curso;
- (void)syncPalabraAvance:(Usuario *)usuario;

- (void)seAcabaDeLoguear:(Usuario *)usuario completion:(void(^)())handler;
- (void)iniciarCurso:(Curso *)curso;
- (void)iniciarRepaso:(Curso *)curso;
- (void)finalizarLeccion:(Curso *)curso;
- (void)elInternetRegreso;


@end
