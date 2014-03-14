//
//  Story.h
//  Argos
//
//  Created by Francis Tseng on 3/13/14.
//  Copyright (c) 2014 Public Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CurrentUser, Entity, Event, Mention;

@interface Story : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) id imageHeader;
@property (nonatomic, retain) id imageMid;
@property (nonatomic, retain) id imageUrl;
@property (nonatomic, retain) id jsonUrl;
@property (nonatomic, retain) NSString * searchQuery;
@property (nonatomic, retain) NSNumber * storyId;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *entities;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *mentions;
@property (nonatomic, retain) CurrentUser *user;
@end

@interface Story (CoreDataGeneratedAccessors)

- (void)addEntitiesObject:(Entity *)value;
- (void)removeEntitiesObject:(Entity *)value;
- (void)addEntities:(NSSet *)values;
- (void)removeEntities:(NSSet *)values;

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addMentionsObject:(Mention *)value;
- (void)removeMentionsObject:(Mention *)value;
- (void)addMentions:(NSSet *)values;
- (void)removeMentions:(NSSet *)values;

@end
