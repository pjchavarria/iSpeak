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
+ (BOOL) updateUsuario: (UsuarioDTO *)user;
+ (void) selectUsuario:(NSString *)userID;
+ (void) selectUsuarioAll;
+ (void) validateUsuario:(NSString *)username Password:(NSString *)password completion:(void (^) (UsuarioDTO *usuario))handler;

@end


@interface CursoParse : NSObject

+ (BOOL) insertCurso:(CursoDTO *)curso;
+ (BOOL) deleteCurso:(NSString *)cursoID;
+ (BOOL) updateCurso:(CursoDTO *)curso;
+ (void) selectCurso:(NSString *)cursoID;
+ (void) selectCursoAll:(void (^) (NSArray *cursos))handler;

@end

@interface PalabraParse : NSObject

+ (BOOL) insertPalabra:(PalabraDTO *)palabra;
+ (BOOL) deletePalabra:(NSString *)palabraID;
+ (BOOL) updatePalabra:(PalabraDTO *)palabra;
+ (void) selectPalabra:(NSString *)palabraID;
+ (void) selectPalabraAll:(void (^) (NSArray *palabras))handler;
+ (void) selectPalabraAllByCursoID:(NSString *)cursoID completion:(void (^) (NSArray *palabrasDelCurso))handler;

@end

@interface PalabraAvanceParse : NSObject

+ (BOOL) insertPalabraAvance:(PalabraAvanceDTO *)palabra completion:(void (^) (NSString *palabraAvanceId))handler;
+ (BOOL) deletePalabraAvance:(NSString *)palabraAvanceID;
+ (BOOL) updatePalabraAvance:(PalabraAvanceDTO *)palabraAvance;
+ (void) selectPalabraAvance:(NSString *)palabraAvanceID;
+ (void) selectPalabraAvanceAll;
+ (void) selectPalabraAvanceAllByUserID:(NSString *)userID;
+ (void) selectPalabraAvanceByUserID:(NSString *)userID palabraID:(NSString *)palabraID completion:(void (^) (NSArray *palabraAvances))handler;

@end

@interface CursoAvanceParse : NSObject

+ (BOOL) insertCursoAvance:(CursoAvanceDTO *)cursoAvance completion:(void (^) (NSString *cursoAvanceId))handler;
+ (BOOL) deleteCursoAvance:(NSString *)cursoAvanceID;
+ (BOOL) updateCursoAvance:(CursoAvanceDTO *)cursoAvance;
+ (void) selectCursoAvance:(NSString *)cursoAvanceID;
+ (void) selectCursoAvanceAll:(void (^) (NSArray *cursoAvances))handler;
+ (void) selectCursoAvanceAllByUserID:(NSString *)userID completion:(void (^) (NSArray *cursoAvances))handler;
+ (void) selectCursoAvanceByUserID:(NSString *)userID cursoID:(NSString *)cursoID completion:(void (^) (NSArray *cursoAvances))handler;

@end

@interface OracionParse : NSObject

+ (BOOL) insertOracion:(OracionDTO *)oracion;
+ (BOOL) deleteOracion:(NSString *)oracionID;
+ (BOOL) updateOracion:(OracionDTO *)oracion;
+ (void) selectOracion:(NSString *)oracionID;
+ (void) selectOracionAll;
+ (void) selectOracionAllByPalabraID:(NSString *)palabraID completion:(void (^) (NSArray *oraciones))handler;

@end

