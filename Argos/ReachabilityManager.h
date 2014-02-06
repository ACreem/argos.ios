//
//  ReachabilityManager.h
//  Argos
//
//  Created by Francis Tseng on 2/6/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

// Reachability singleton.

#import <Foundation/Foundation.h>

@class Reachability;

@interface ReachabilityManager : NSObject

@property (strong, nonatomic) Reachability *reachability;

#pragma mark Shared Manager
+ (ReachabilityManager *)sharedManager;

#pragma mark Class Methods
+ (BOOL)isReachable;
+ (BOOL)isUnreachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;

@end
