//
//  PalabraAvance.h
//  iSpeak
//
//  Created by Paul on 16/05/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Palabra, Usuario;

@interface PalabraAvance : NSManagedObject

@property (nonatomic, retain) NSNumber * avance;
@property (nonatomic, retain) NSNumber * estado;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSNumber * prioridad;
@property (nonatomic, retain) NSNumber * sincronizado;
@property (nonatomic, retain) NSDate * ultimaFechaRepaso;
@property (nonatomic, retain) NSDate * ultimaSincronizacion;
@property (nonatomic, retain) Palabra *palabra;
@property (nonatomic, retain) Usuario *usuario;

@end
