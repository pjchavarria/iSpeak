//
//  UsuarioDTO.h
//  XProjectModel
//
//  Created by Daniel Soto on 5/14/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTO : NSObject

@end


@interface UsuarioDTO : NSObject
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * objectId;
@end


@interface OracionDTO : NSObject
@property (nonatomic, strong) NSData * audio;
@property (nonatomic, strong) NSString * oracion;
@property (nonatomic, strong) NSString * traduccion;
@property (nonatomic, strong) NSString * objectId;
@property (nonatomic, strong) NSString *palabra;
@end


@interface PalabraDTO : NSObject
@property (nonatomic, retain) NSData * audio;
@property (nonatomic, retain) NSString * palabra;
@property (nonatomic, retain) NSString * traduccion;
@property (nonatomic, retain) NSNumber * tipoPalabra;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString *curso;
@property (nonatomic, retain) NSSet *oraciones;
@end

@interface PalabraAvanceDTO : NSObject
@property (nonatomic, retain) NSNumber * avance;
@property (nonatomic, retain) NSNumber * estado;
@property (nonatomic, retain) NSNumber * prioridad;
@property (nonatomic, retain) NSDate * ultimaFechaRepaso;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSNumber *sincronizado;
@property (nonatomic, retain) NSString *usuario;
@property (nonatomic, retain) NSString *palabra;
@property (nonatomic, retain) NSDate *ultimaSincronizacion;
@end


@interface CursoDTO : NSObject
@property (nonatomic, retain) NSNumber * cantidadPalabras;
@property (nonatomic, retain) NSNumber * curso;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSSet *palabras;
@end

@interface CursoAvanceDTO : NSObject
@property (nonatomic, retain) NSNumber * avance;
@property (nonatomic, retain) NSNumber * palabrasComenzadas;
@property (nonatomic, retain) NSNumber * palabrasCompletas;
@property (nonatomic, retain) NSNumber * tiempoEstudiado;
@property (nonatomic, retain) NSString *objectId;
@property (nonatomic, retain) NSNumber *sincronizado;
@property (nonatomic, retain) NSString *usuario;
@property (nonatomic, retain) NSString *curso;
@property (nonatomic, retain) NSDate *ultimaSincronizacion;
@end



