//
//  Curso.h
//  iSpeak
//
//  Created by Paul on 16/05/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CursoAvance, Palabra;

@interface Curso : NSManagedObject

@property (nonatomic, retain) NSNumber * cantidadPalabras;
@property (nonatomic, retain) NSNumber * curso;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSSet *cursoAvance;
@property (nonatomic, retain) NSSet *palabras;
@property (nonatomic, retain) NSDate * ultimaSincronizacion;
@end

@interface Curso (CoreDataGeneratedAccessors)

- (void)addCursoAvanceObject:(CursoAvance *)value;
- (void)removeCursoAvanceObject:(CursoAvance *)value;
- (void)addCursoAvance:(NSSet *)values;
- (void)removeCursoAvance:(NSSet *)values;

- (void)addPalabrasObject:(Palabra *)value;
- (void)removePalabrasObject:(Palabra *)value;
- (void)addPalabras:(NSSet *)values;
- (void)removePalabras:(NSSet *)values;

@end
