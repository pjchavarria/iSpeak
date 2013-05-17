//
//  Palabra.h
//  iSpeak
//
//  Created by Paul on 16/05/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Curso, Oracion, PalabraAvance;

@interface Palabra : NSManagedObject

@property (nonatomic, retain) NSData * audio;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * palabra;
@property (nonatomic, retain) NSNumber * tipoPalabra;
@property (nonatomic, retain) NSString * traduccion;
@property (nonatomic, retain) Curso *curso;
@property (nonatomic, retain) NSSet *oraciones;
@property (nonatomic, retain) NSSet *palabraAvance;
@end

@interface Palabra (CoreDataGeneratedAccessors)

- (void)addOracionesObject:(Oracion *)value;
- (void)removeOracionesObject:(Oracion *)value;
- (void)addOraciones:(NSSet *)values;
- (void)removeOraciones:(NSSet *)values;

- (void)addPalabraAvanceObject:(PalabraAvance *)value;
- (void)removePalabraAvanceObject:(PalabraAvance *)value;
- (void)addPalabraAvance:(NSSet *)values;
- (void)removePalabraAvance:(NSSet *)values;

@end
