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

@class CurrentUser, Event;

@interface Story : BaseEntity

@property (nonatomic, retain) NSNumber * storyId;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) CurrentUser *user;
@end

@interface Story (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
