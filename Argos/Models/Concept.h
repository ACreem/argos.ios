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

@class Event, Mention, Story;

@interface Concept : BaseEntity

@property (nonatomic, retain) NSString * conceptId;
@property (nonatomic, retain) NSSet *aliases;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *stories;
@end

@interface Concept (CoreDataGeneratedAccessors)

- (void)addAliasesObject:(Mention *)value;
- (void)removeAliasesObject:(Mention *)value;
- (void)addAliases:(NSSet *)values;
- (void)removeAliases:(NSSet *)values;

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addStoriesObject:(Story *)value;
- (void)removeStoriesObject:(Story *)value;
- (void)addStories:(NSSet *)values;
- (void)removeStories:(NSSet *)values;

@end
