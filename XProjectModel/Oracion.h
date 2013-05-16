//
//  Oracion.h
//  iSpeak
//
//  Created by Lion User on 16/05/2013.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Palabra;

@interface Oracion : NSManagedObject

@property (nonatomic, retain) NSData * audio;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * oracion;
@property (nonatomic, retain) NSString * traduccion;
@property (nonatomic, retain) Palabra *palabra;

@end
