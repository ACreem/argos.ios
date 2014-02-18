//
//  Story.h
//  Argos
//
//  Created by Francis Tseng on 2/17/14.
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
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) Entity *entities;
@end

@interface Story (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
