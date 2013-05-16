//
//  Oracion.h
//  XProjectModel
//
//  Created by Daniel Soto on 5/14/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Palabra;

@interface Oracion : NSManagedObject

@property (nonatomic, retain) NSData * audio;
@property (nonatomic, retain) NSString * oracion;
@property (nonatomic, retain) NSString * traduccion;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) Palabra *palabra;

@end
