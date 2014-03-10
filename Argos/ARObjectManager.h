//
//  ARObjectManager.h
//  Argos
//
//  Created by Francis Tseng on 2/12/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "RKObjectManager.h"
#import "AFOAuth2Client.h"
#import "CurrentUser.h"

static NSString* const kArgosLatestStream = @"latest";
static NSString* const kArgosTrendingStream = @"trending";
static NSString* const kArgosWatchingStream = @"watching";
static NSString* const kArgosBookmarkedStream = @"bookmarked";

@interface ARObjectManager : RKObjectManager

+ (ARObjectManager*)objectManagerWithManagedObjectStore:(RKManagedObjectStore*)mos;
+ (ARObjectManager*)sharedManager;

- (CurrentUser*)currentUser;
- (void)logoutCurrentUser;
- (void)loginCurrentUserWithEmail:(NSString*)email
                         password:(NSString*)password
                          success:(void (^)(CurrentUser *currentUser))success
                          failure:(void (^)(NSError *error))failure;

- (AFOAuth2Client*)client;

@end
