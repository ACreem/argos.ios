//
//  CurrentUser.h
//  Argos
//
//  Created by Francis Tseng on 3/13/14.
//  Copyright (c) 2014 Public Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Story;

@interface CurrentUser : NSManagedObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSSet *bookmarked;
@property (nonatomic, retain) NSSet *watching;
@end

@interface CurrentUser (CoreDataGeneratedAccessors)

- (void)addBookmarkedObject:(Event *)value;
- (void)removeBookmarkedObject:(Event *)value;
- (void)addBookmarked:(NSSet *)values;
- (void)removeBookmarked:(NSSet *)values;

- (void)addWatchingObject:(Story *)value;
- (void)removeWatchingObject:(Story *)value;
- (void)addWatching:(NSSet *)values;
- (void)removeWatching:(NSSet *)values;

@end
