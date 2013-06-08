//
//  Usuario.h
//  iSpeak
//
//  Created by Lion User on 16/05/2013.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Usuario : NSManagedObject

@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *palabraAvance;
@property (nonatomic, retain) NSDate * ultimaSincronizacion;
@end

@interface Usuario (CoreDataGeneratedAccessors)

- (void)addPalabraAvanceObject:(NSManagedObject *)value;
- (void)removePalabraAvanceObject:(NSManagedObject *)value;
- (void)addPalabraAvance:(NSSet *)values;
- (void)removePalabraAvance:(NSSet *)values;

@end
