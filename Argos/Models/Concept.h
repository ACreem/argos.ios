//
//  Concept.h
//  Argos
//
//  Created by Francis Tseng on 3/14/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"

@class BaseEntity, Mention;

@interface Concept : BaseEntity

@property (nonatomic, retain) NSString * conceptId;
@property (nonatomic, retain) NSSet *aliases;
@property (nonatomic, retain) NSSet *entities;
@end

@interface Concept (CoreDataGeneratedAccessors)

- (void)addAliasesObject:(Mention *)value;
- (void)removeAliasesObject:(Mention *)value;
- (void)addAliases:(NSSet *)values;
- (void)removeAliases:(NSSet *)values;

- (void)addEntitiesObject:(BaseEntity *)value;
- (void)removeEntitiesObject:(BaseEntity *)value;
- (void)addEntities:(NSSet *)values;
- (void)removeEntities:(NSSet *)values;

@end
