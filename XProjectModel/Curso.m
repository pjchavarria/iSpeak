//
//  Curso.m
//  iSpeak
//
//  Created by Paul on 16/05/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import "Curso.h"
#import "CursoAvance.h"
#import "Palabra.h"


@implementation Curso

@dynamic cantidadPalabras;
@dynamic curso;
@dynamic nombre;
@dynamic objectId;
@dynamic cursoAvance;
@dynamic palabras;

-(NSString *)description
{
	return [NSString stringWithFormat:@"%@ ,%@",self.objectId,self.nombre];
}

@end
