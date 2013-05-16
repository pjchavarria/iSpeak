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
@property (nonatomic, retain) NSData * audio;
@property (nonatomic, retain) NSNumber * avance;
@property (nonatomic, retain) NSNumber * estado;
@property (nonatomic, retain) NSString * palabra;
@property (nonatomic, retain) NSNumber * prioridad;
@property (nonatomic, retain) NSString * traduccion;
@property (nonatomic, retain) NSDate * ultimaFechaRepaso;
@property (nonatomic, retain) NSNumber * tipoPalabra;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString *curso;
@property (nonatomic, retain) NSSet *oraciones;
@end


@interface CursoDTO : NSObject
@property (nonatomic, retain) NSNumber * avance;
@property (nonatomic, retain) NSNumber * cantidadPalabras;
@property (nonatomic, retain) NSNumber * curso;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSNumber * palabrasCompletas;
@property (nonatomic, retain) NSNumber * tiempoEstudiando;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString *nivel;
@property (nonatomic, retain) NSSet *palabras;
@end



