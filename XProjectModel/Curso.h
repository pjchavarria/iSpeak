//
//  Curso.h
//  XProjectModel
//
//  Created by Daniel Soto on 5/14/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Nivel, Palabra;

@interface Curso : NSManagedObject

@property (nonatomic, retain) NSNumber * avance;
@property (nonatomic, retain) NSNumber * cantidadPalabras;
@property (nonatomic, retain) NSNumber * curso;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSNumber * palabrasCompletas;
@property (nonatomic, retain) NSNumber * tiempoEstudiando;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) Nivel *nivel;
@property (nonatomic, retain) NSSet *palabras;
@end

@interface Curso (CoreDataGeneratedAccessors)

- (void)addPalabrasObject:(Palabra *)value;
- (void)removePalabrasObject:(Palabra *)value;
- (void)addPalabras:(NSSet *)values;
- (void)removePalabras:(NSSet *)values;

@end
