//
//  UsuarioDTO.m
//  XProjectModel
//
//  Created by Daniel Soto on 5/14/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import "DTO.h"


@implementation DTO
@end

@implementation UsuarioDTO
@dynamic password;
@dynamic username;
+ (NSString *)parseClassName{
	return @"Usuario";
}
@end


@implementation OracionDTO
 @dynamic audio;
 @dynamic oracion;
 @dynamic traduccion;
+ (NSString *)parseClassName{
	return @"Oracion";
}
- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ %@",self.objectId,self.oracion];
}
@end


@implementation PalabraDTO
@dynamic audio;
@dynamic palabra;
@dynamic traduccion;
@dynamic tipoPalabra;
@dynamic oraciones;
+ (NSString *)parseClassName{
	return @"Palabra";
}
- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ %@",self.objectId,self.palabra];
}
@end



@implementation CursoDTO
@dynamic cantidadPalabras;
@dynamic curso;
@dynamic nombre;
@dynamic palabras;
+ (NSString *)parseClassName{
	return @"Curso";
}
- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ %@",self.objectId,self.nombre];
}
@end



@implementation PalabraAvanceDTO
@dynamic avance;
@dynamic estado;
@dynamic prioridad;
@dynamic ultimaFechaRepaso;
@dynamic sincronizado;
@dynamic usuario;
@dynamic palabra;
@dynamic curso;
+ (NSString *)parseClassName{
	return @"PalabraAvance";
}
- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ %@",self.objectId,self.updatedAt];
}
@end

@implementation CursoAvanceDTO
@dynamic avance;
@dynamic palabrasComenzadas;
@dynamic palabrasCompletas;
@dynamic palabrasTotales;
@dynamic tiempoEstudiado;
@dynamic sincronizado;
@dynamic curso;
@dynamic usuario;
+ (NSString *)parseClassName{
	return @"CursoAvance";
}
- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ %@ %@",self.objectId,self.updatedAt,self.curso];
}
@end
