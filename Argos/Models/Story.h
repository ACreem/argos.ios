//
//  Story.h
//  Argos
//
//  Created by Francis Tseng on 3/14/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"

@class Concept, CurrentUser, Event, Mention;

@interface Story : BaseEntity

@property (nonatomic, retain) NSNumber * storyId;
@property (nonatomic, retain) NSSet *concepts;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *mentions;
@property (nonatomic, retain) CurrentUser *user;
@end

@interface Story (CoreDataGeneratedAccessors)

- (void)addConceptsObject:(Concept *)value;
- (void)removeConceptsObject:(Concept *)value;
- (void)addConcepts:(NSSet *)values;
- (void)removeConcepts:(NSSet *)values;

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addMentionsObject:(Mention *)value;
- (void)removeMentionsObject:(Mention *)value;
- (void)addMentions:(NSSet *)values;
- (void)removeMentions:(NSSet *)values;

@end
