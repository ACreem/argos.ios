//
//  Event+Management.h
//  Argos
//
//  Created by Francis Tseng on 3/14/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "Event.h"

@interface Event (Management)

- (void)bookmark;
- (void)unbookmark;
- (BOOL)isBookmarked;
- (void)checkBookmarked:(void (^)(Event *))bookmarked notBookmarked:(void (^)(Event *))notBookmarked;
- (BOOL)isWatched;
- (void)checkWatched:(void (^)(Story *))watched notWatched:(void (^)(Story *))notWatched;

@end
