//
//  Event.h
//  Argos
//
//  Created by Francis Tseng on 3/13/14.
//  Copyright (c) 2014 Public Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Article, CurrentUser, Entity, Mention, Story;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * eventId;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) id imageFull;
@property (nonatomic, retain) id imageHeader;
@property (nonatomic, retain) id imageMid;
@property (nonatomic, retain) id imageUrl;
@property (nonatomic, retain) id jsonUrl;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * searchQuery;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *articles;
@property (nonatomic, retain) NSSet *entities;
@property (nonatomic, retain) NSSet *mentions;
@property (nonatomic, retain) NSSet *stories;
@property (nonatomic, retain) CurrentUser *user;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(Article *)value;
- (void)removeArticlesObject:(Article *)value;
- (void)addArticles:(NSSet *)values;
- (void)removeArticles:(NSSet *)values;

- (void)addEntitiesObject:(Entity *)value;
- (void)removeEntitiesObject:(Entity *)value;
- (void)addEntities:(NSSet *)values;
- (void)removeEntities:(NSSet *)values;

- (void)addMentionsObject:(Mention *)value;
- (void)removeMentionsObject:(Mention *)value;
- (void)addMentions:(NSSet *)values;
- (void)removeMentions:(NSSet *)values;

- (void)addStoriesObject:(Story *)value;
- (void)removeStoriesObject:(Story *)value;
- (void)addStories:(NSSet *)values;
- (void)removeStories:(NSSet *)values;

@end