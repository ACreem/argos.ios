//
//  Mention.h
//  Argos
//
//  Created by Francis Tseng on 3/17/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BaseEntity, Concept;

@interface Mention : NSManagedObject

@property (nonatomic, retain) NSNumber * mentionId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Concept *concept;
@property (nonatomic, retain) NSSet *entities;
@end

@interface Mention (CoreDataGeneratedAccessors)

- (void)addEntitiesObject:(BaseEntity *)value;
- (void)removeEntitiesObject:(BaseEntity *)value;
- (void)addEntities:(NSSet *)values;
- (void)removeEntities:(NSSet *)values;

@end
