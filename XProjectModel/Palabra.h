//
//  Palabra.h
//  XProjectModel
//
//  Created by Daniel Soto on 5/14/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Curso, Oracion;

@interface Palabra : NSManagedObject

@property (nonatomic, retain) NSData * audio;
@property (nonatomic, retain) NSNumber * avance;
@property (nonatomic, retain) NSNumber * estado;
@property (nonatomic, retain) NSString * palabra;
@property (nonatomic, retain) NSNumber * prioridad;
@property (nonatomic, retain) NSString * traduccion;
@property (nonatomic, retain) NSDate * ultimaFechaRepaso;
@property (nonatomic, retain) NSNumber * tipoPalabra;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) Curso *curso;
@property (nonatomic, retain) NSSet *oraciones;
@end

@interface Palabra (CoreDataGeneratedAccessors)

- (void)addOracionesObject:(Oracion *)value;
- (void)removeOracionesObject:(Oracion *)value;
- (void)addOraciones:(NSSet *)values;
- (void)removeOraciones:(NSSet *)values;

@end
