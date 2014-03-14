//
//  Event+Management.m
//  Argos
//
//  Created by Francis Tseng on 3/14/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "Event+Management.h"
#import "CurrentUser+Management.h"

@implementation Event (Management)

- (void)bookmark
{
    [[[ARObjectManager sharedManager] client] postPath:@"/user/bookmarked"
                                            parameters:@{@"event_id": self.eventId}
                                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                   [[CurrentUser currentUser] addBookmarkedObject:self];
                                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                   NSLog(@"Error bookmarking event: %@", error);
                                               }];
}

- (void)unbookmark
{
    [[[ARObjectManager sharedManager] client] deletePath:[NSString stringWithFormat:@"/user/bookmarked/%@", self.eventId]
                                              parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  [[CurrentUser currentUser] removeBookmarkedObject:self];
                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Error unbookmarking event: %@", error);
                                              }];
}

- (BOOL)isBookmarked
{
    return [[CurrentUser currentUser].bookmarked containsObject:self];
}

- (void)checkBookmarked:(void (^)(Event *))bookmarked notBookmarked:(void (^)(Event *))notBookmarked
{
    [[[ARObjectManager sharedManager] client] getPath:[NSString stringWithFormat:@"/user/bookmarked/%@", self.eventId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[CurrentUser currentUser] addBookmarkedObject:self];
        if (bookmarked) {
            bookmarked(self);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([operation.response statusCode] == 404) {
            [[CurrentUser currentUser] removeBookmarkedObject:self];
            if (notBookmarked) {
                notBookmarked(self);
            }
        } else {
            NSLog(@"Bookmark checking failed with non-404 error: %@", error);
        }
    }];
}

@end
