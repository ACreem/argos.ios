//
//  Mention.h
//  Argos
//
//  Created by Francis Tseng on 3/13/14.
//  Copyright (c) 2014 Public Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entity, Event, Story;

@interface Mention : NSManagedObject

@property (nonatomic, retain) NSNumber * mentionId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) Entity *parent;
@property (nonatomic, retain) NSSet *stories;
@end

@interface Mention (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addStoriesObject:(Story *)value;
- (void)removeStoriesObject:(Story *)value;
- (void)addStories:(NSSet *)values;
- (void)removeStories:(NSSet *)values;

@end
