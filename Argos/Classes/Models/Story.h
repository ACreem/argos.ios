//
//  Story.h
//  Argos
//
//  Created by Francis Tseng on 2/19/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entity, Event;

@interface Story : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) id jsonUrl;
@property (nonatomic, retain) NSNumber * storyId;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) id imageUrl;
@property (nonatomic, retain) NSSet *entities;
@property (nonatomic, retain) NSSet *events;
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

@end
