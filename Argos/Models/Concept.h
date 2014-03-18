//
//  Concept.h
//  Argos
//
//  Created by Francis Tseng on 3/17/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"

@class Concept, Event, Mention, Story;

@interface Concept : BaseEntity

@property (nonatomic, retain) NSString * conceptId;
@property (nonatomic, retain) NSSet *aliases;
@property (nonatomic, retain) NSSet *stories;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *concepts;
@property (nonatomic, retain) NSSet *from_concepts;
@end

@interface Concept (CoreDataGeneratedAccessors)

- (void)addAliasesObject:(Mention *)value;
- (void)removeAliasesObject:(Mention *)value;
- (void)addAliases:(NSSet *)values;
- (void)removeAliases:(NSSet *)values;

- (void)addStoriesObject:(Story *)value;
- (void)removeStoriesObject:(Story *)value;
- (void)addStories:(NSSet *)values;
- (void)removeStories:(NSSet *)values;

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addConceptsObject:(Concept *)value;
- (void)removeConceptsObject:(Concept *)value;
- (void)addConcepts:(NSSet *)values;
- (void)removeConcepts:(NSSet *)values;

- (void)addFrom_conceptsObject:(Concept *)value;
- (void)removeFrom_conceptsObject:(Concept *)value;
- (void)addFrom_concepts:(NSSet *)values;
- (void)removeFrom_concepts:(NSSet *)values;

@end
