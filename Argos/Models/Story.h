//
//  Story.h
//  Argos
//
//  Created by Francis Tseng on 3/17/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"

@class Concept, CurrentUser, Event;

@interface Story : BaseEntity

@property (nonatomic, retain) NSNumber * storyId;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) CurrentUser *user;
@property (nonatomic, retain) NSSet *concepts;
@end

@interface Story (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addConceptsObject:(Concept *)value;
- (void)removeConceptsObject:(Concept *)value;
- (void)addConcepts:(NSSet *)values;
- (void)removeConcepts:(NSSet *)values;

@end
