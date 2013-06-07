//
//  UsuarioDTO.h
//  XProjectModel
//
//  Created by Daniel Soto on 5/14/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/PFObject+Subclass.h>
@interface DTO : NSObject

@end	


@interface UsuarioDTO : PFObject<PFSubclassing>
@property (retain) NSString * password;
@property (retain) NSString * username;
+ (NSString *)parseClassName;
@end


@interface OracionDTO : PFObject<PFSubclassing>
@property ( retain) NSData * audio;
@property ( retain) NSString * oracion;
@property ( retain) NSString * traduccion;
@property ( retain) NSString *palabra;
+ (NSString *)parseClassName;
@end


@interface PalabraDTO : PFObject<PFSubclassing>
@property ( retain) NSData * audio;
@property ( retain) NSString * palabra;
@property ( retain) NSString * traduccion;
@property ( retain) NSNumber * tipoPalabra;
@property ( retain) NSString *curso;
@property ( retain) NSSet *oraciones;
+ (NSString *)parseClassName;
@end

@interface PalabraAvanceDTO : PFObject<PFSubclassing>
@property ( retain) NSNumber * avance;
@property ( retain) NSNumber * estado;
@property ( retain) NSNumber * prioridad;
@property ( retain) NSDate * ultimaFechaRepaso;
@property ( retain) NSNumber * sincronizado;
@property ( retain) NSString *usuario;
@property ( retain) NSString *palabra;
@property ( retain) NSDate *ultimaSincronizacion;
+ (NSString *)parseClassName;
@end


@interface CursoDTO : PFObject<PFSubclassing>
@property ( retain) NSNumber * cantidadPalabras;
@property ( retain) NSNumber * curso;
@property ( retain) NSString * nombre;
@property ( retain) NSSet *palabras;
+ (NSString *)parseClassName;
@end

@interface CursoAvanceDTO : PFObject<PFSubclassing>
@property ( retain) NSNumber * avance;
@property ( retain) NSNumber * palabrasComenzadas;
@property ( retain) NSNumber * palabrasCompletas;
@property ( retain) NSNumber * tiempoEstudiado;
@property ( retain) NSNumber * sincronizado;
@property ( retain) NSString *usuario;
@property ( retain) NSString *curso;
@property ( retain) NSDate *ultimaSincronizacion;
+ (NSString *)parseClassName;
@end



