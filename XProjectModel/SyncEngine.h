//
//  SyncEngine.h
//  iSpeak
//
//  Created by Paul on 16/05/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Usuario,Curso,Palabra,UsuarioDTO;
@interface SyncEngine : NSObject

+ (SyncEngine *)sharedEngine;
- (void)syncUser:(UsuarioDTO *)data;

- (void)syncCursoAvanceConUsuario:(Usuario *)usuario curso:(Curso *)curso completion:(void(^)())handler;
- (void)syncPalabraAvanceConUsuario:(Usuario *)usuario palabra:(Palabra*)palabra completion:(void(^)())handler;

- (void)seAcabaDeLoguear:(Usuario *)usuario completion:(void(^)())handler;
- (void)iniciarCurso:(Curso *)curso completion:(void(^)())handler;
- (void)iniciarRepaso:(Curso *)curso completion:(void(^)())handler;
- (void)finalizarLeccion:(Curso *)curso completion:(void(^)())handler;
- (void)elInternetRegresoCompletion:(void(^)())handler;


@end
