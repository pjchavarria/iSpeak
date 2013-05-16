//
//  CursoAvance.h
//  iSpeak
//
//  Created by Lion User on 16/05/2013.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CursoAvance : NSManagedObject

@property (nonatomic, retain) NSNumber * avance;
@property (nonatomic, retain) NSNumber * palabrasComenzadas;
@property (nonatomic, retain) NSNumber * palabrasCompletas;
@property (nonatomic, retain) NSNumber * tiempoEstudiado;
@property (nonatomic, retain) NSNumber * objectId;

@end
