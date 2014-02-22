//
//  ReachabilityManager.m
//  Argos
//
//  Created by Francis Tseng on 2/6/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ReachabilityManager.h"
#import "Reachability.h"

@implementation ReachabilityManager

#pragma mark - Default manager
+ (ReachabilityManager *)sharedManager {
    static ReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark - Memory Management
- (void)dealloc {
    // Stop notifier
    if (_reachability) {
        [_reachability stopNotifier];
    }
}

#pragma mark - Class Methods
+ (BOOL)isReachable {
    return [[[ReachabilityManager sharedManager] reachability] isReachable];
}
+ (BOOL)isUnreachable {
    return ![[[ReachabilityManager sharedManager] reachability] isReachable];
}
+ (BOOL)isReachableViaWWAN {
    return ![[[ReachabilityManager sharedManager] reachability] isReachableViaWWAN];
}
+ (BOOL)isReachableViaWiFi {
    return ![[[ReachabilityManager sharedManager] reachability] isReachableViaWiFi];
}

# pragma mark - Private Initialization
- (id)init {
    self = [super init];
    if (self) {
        self.reachability = [Reachability reachabilityWithHostname:kArgosAPIBaseURLString];
        
        // Start monitoring
        [self.reachability startNotifier];
    }
    return self;
}

@end
