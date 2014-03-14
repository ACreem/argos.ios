//
//  Story+Management.m
//  Argos
//
//  Created by Francis Tseng on 3/14/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "Story+Management.h"
#import "CurrentUser+Management.h"

@implementation Story (Management)

- (void)watch
{
    [[[ARObjectManager sharedManager] client] postPath:@"/user/watching"
                                            parameters:@{@"story_id": self.storyId}
                                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                   [[CurrentUser currentUser] addWatchingObject:self];
                                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                   NSLog(@"Error watching story: %@", error);
                                               }];
}

- (void)unwatch
{
    [[[ARObjectManager sharedManager] client] deletePath:[NSString stringWithFormat:@"/user/watching/%@", self.storyId]
                                              parameters:nil
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     [[CurrentUser currentUser] removeWatchingObject:self];
                                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     NSLog(@"Error unwatching story: %@", error);
                                                 }];
}

- (BOOL)isWatched
{
    return [[CurrentUser currentUser].watching containsObject:self];
}

- (void)checkWatched:(void (^)(Story *))watched notWatched:(void (^)(Story *))notWatched
{
    [[[ARObjectManager sharedManager] client] getPath:[NSString stringWithFormat:@"/user/watching/%@", self.storyId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[CurrentUser currentUser] addWatchingObject:self];
        if (watched) {
            watched(self);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([operation.response statusCode] == 404) {
            [[CurrentUser currentUser] removeWatchingObject:self];
            if (notWatched) {
                notWatched(self);
            }
        } else {
            NSLog(@"Watching checking failed with non-404 error: %@", error);
        }
    }];
}

@end
