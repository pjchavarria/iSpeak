//
//  Curso.h
//  iSpeak
//
//  Created by Lion User on 16/05/2013.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Palabra;

@interface Curso : NSManagedObject

@property (nonatomic, retain) NSNumber * avance;
@property (nonatomic, retain) NSNumber * cantidadPalabras;
@property (nonatomic, retain) NSNumber * curso;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSNumber * palabrasCompletas;
@property (nonatomic, retain) NSNumber * tiempoEstudiando;
@property (nonatomic, retain) NSNumber * palabrasComenzadas;
@property (nonatomic, retain) NSSet *palabras;
@end

@interface Curso (CoreDataGeneratedAccessors)

- (void)addPalabrasObject:(Palabra *)value;
- (void)removePalabrasObject:(Palabra *)value;
- (void)addPalabras:(NSSet *)values;
- (void)removePalabras:(NSSet *)values;

@end
