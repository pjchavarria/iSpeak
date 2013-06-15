//
//  CursoAvance.m
//  iSpeak
//
//  Created by Paul on 16/05/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import "CursoAvance.h"
#import "Curso.h"
#import "Usuario.h"


@implementation CursoAvance

@dynamic avance;
@dynamic objectId;
@dynamic palabrasComenzadas;
@dynamic palabrasCompletas;
@dynamic sincronizado;
@dynamic tiempoEstudiado;
@dynamic ultimaSincronizacion;
@dynamic curso;
@dynamic usuario;

-(NSString *)description
{
	return [NSString stringWithFormat:@"ID: %@ ,Tiempo estudiado: %@",self.objectId,self.tiempoEstudiado];
}

@end
