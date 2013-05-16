//
//  ParseUtilities.h
//  XProjectModel
//
//  Created by Daniel Soto on 5/13/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#import "Oracion.h"
#import "Curso.h"
#import "Palabra.h"
#import "DTO.h"

@interface ParseUtilities : NSObject

@end

@interface UsuarioParse : NSObject

+ (BOOL)insertUsuario:(UsuarioDTO *)user;
+ (BOOL) deleteUsuario:(NSString *)userID;
+(BOOL) updateUsuario: (UsuarioDTO *)user;
+ (void) selectUsuario:(NSString *)userID;
+ (void) selectUsuarioAll;
+ (void) validateUsuario:(NSString *)username Password:(NSString *)password;

@end


@interface CursoParse : NSObject

+ (BOOL)insertCurso:(CursoDTO *)curso;
+ (BOOL) deleteCurso:(NSString *)cursoID;
+(BOOL) updateCurso: (CursoDTO *)curso;
+ (void) selectCurso:(NSString *)cursoID;
+ (void) selectCursoAll;
+ (void) selectCursoAllByNivelID:(NSString *)nivelID;

@end

@interface PalabraParse : NSObject

+ (BOOL)insertPalabra:(PalabraDTO *)palabra;
+ (BOOL) deletePalabra:(NSString *)palabraID;
+(BOOL) updatePalabra: (PalabraDTO *)palabra;
+ (void) selectPalabra:(NSString *)palabraID;
+ (void) selectPalabraAll;
+ (void) selectPalabraAllByCursoID:(NSString *)cursoID;

@end

@interface OracionParse : NSObject

+ (BOOL)insertOracion:(OracionDTO *)oracion;
+ (BOOL) deleteOracion:(NSString *)oracionID;
+(BOOL) updateOracion: (OracionDTO *)oracion;
+ (void) selectOracion:(NSString *)oracionID;
+ (void) selectOracionAll;
+(void) selectOracionAllByPalabraID:(NSString *)palabraID;

@end

