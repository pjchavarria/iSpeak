//
//  PalabraAvance.h
//  iSpeak
//
//  Created by Lion User on 16/05/2013.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Palabra, Usuario;

@interface PalabraAvance : NSManagedObject

@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSNumber * avance;
@property (nonatomic, retain) NSNumber * estado;
@property (nonatomic, retain) NSNumber * prioridad;
@property (nonatomic, retain) NSDate * ultimaFechaRepaso;
@property (nonatomic, retain) Palabra *palabra;
@property (nonatomic, retain) Usuario *usuario;

@end
