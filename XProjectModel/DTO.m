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
-(NSString *)description{
    return self.password;
}
@end

@implementation OracionDTO
@end

@implementation PalabraDTO
@end

@implementation PalabraAvanceDTO
@end

@implementation CursoDTO
- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ %@",self.objectId,self.nombre];
}
@end

@implementation CursoAvanceDTO
@end


