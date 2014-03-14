//
//  Entity.h
//  Argos
//
//  Created by Francis Tseng on 3/13/14.
//  Copyright (c) 2014 Public Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Mention, Story;

@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * entityId;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) id imageHeader;
@property (nonatomic, retain) id imageLarge;
@property (nonatomic, retain) id imageMid;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) id jsonUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * searchQuery;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *aliases;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *stories;
@end

@interface Entity (CoreDataGeneratedAccessors)

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
