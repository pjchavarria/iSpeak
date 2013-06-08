//
//  Oracion.m
//  iSpeak
//
//  Created by Lion User on 16/05/2013.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import "Oracion.h"
#import "Palabra.h"


@implementation Oracion

@dynamic audio;
@dynamic objectId;
@dynamic oracion;
@dynamic traduccion;
@dynamic palabra;
-(NSString *)description
{
	return [NSString stringWithFormat:@"%@ ,%@",self.objectId,self.oracion];
}
@end
