//
//  Image.h
//  Argos
//
//  Created by Francis Tseng on 3/14/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BaseEntity;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSSet *entities;
@end

@interface Image (CoreDataGeneratedAccessors)

- (void)addEntitiesObject:(BaseEntity *)value;
- (void)removeEntitiesObject:(BaseEntity *)value;
- (void)addEntities:(NSSet *)values;
- (void)removeEntities:(NSSet *)values;

@end
