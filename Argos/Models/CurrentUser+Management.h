//
//  CurrentUser+Management.h
//  Argos
//
//  Created by Francis Tseng on 3/13/14.
//  Copyright (c) 2014 Public Science. All rights reserved.
//

#import "CurrentUser.h"

@interface CurrentUser (Management)

+ (CurrentUser*)currentUser;
+ (void)logout;
+ (void)loginWithEmail:(NSString*)email
              password:(NSString*)password
               success:(void (^)(CurrentUser *currentUser))success
               failure:(void (^)(NSError *error))failure;

@end
