//
//  Event.h
//  Argos
//
//  Created by Francis Tseng on 3/14/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"

@class Article, Concept, CurrentUser, Mention, Story;

@interface Event : BaseEntity

@property (nonatomic, retain) NSNumber * eventId;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSSet *articles;
@property (nonatomic, retain) NSSet *concepts;
@property (nonatomic, retain) NSSet *mentions;
@property (nonatomic, retain) NSSet *stories;
@property (nonatomic, retain) CurrentUser *user;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(Article *)value;
- (void)removeArticlesObject:(Article *)value;
- (void)addArticles:(NSSet *)values;
- (void)removeArticles:(NSSet *)values;

- (void)addConceptsObject:(Concept *)value;
- (void)removeConceptsObject:(Concept *)value;
- (void)addConcepts:(NSSet *)values;
- (void)removeConcepts:(NSSet *)values;

- (void)addMentionsObject:(Mention *)value;
- (void)removeMentionsObject:(Mention *)value;
- (void)addMentions:(NSSet *)values;
- (void)removeMentions:(NSSet *)values;

- (void)addStoriesObject:(Story *)value;
- (void)removeStoriesObject:(Story *)value;
- (void)addStories:(NSSet *)values;
- (void)removeStories:(NSSet *)values;

@end
