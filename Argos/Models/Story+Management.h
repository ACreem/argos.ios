//
//  Story+Management.h
//  Argos
//
//  Created by Francis Tseng on 3/14/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "Story.h"

@interface Story (Management)

- (void)watch;
- (void)unwatch;
- (BOOL)isWatched;
- (void)checkWatched:(void (^)(Story *))watched notWatched:(void (^)(Story *))notWatched;

@end
