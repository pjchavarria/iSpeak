//
//  CursoAvance.h
//  iSpeak
//
//  Created by Paul on 16/05/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Curso, Usuario;

@interface CursoAvance : NSManagedObject

@property (nonatomic, retain) NSNumber * avance;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSNumber * palabrasComenzadas;
@property (nonatomic, retain) NSNumber * palabrasCompletas;
@property (nonatomic, retain) NSNumber * sincronizado;
@property (nonatomic, retain) NSNumber * tiempoEstudiado;
@property (nonatomic, retain) NSDate * ultimaSincronizacion;
@property (nonatomic, retain) Curso *curso;
@property (nonatomic, retain) Usuario *usuario;

@end
