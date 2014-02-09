//
//  ArgosClient.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ArgosClient.h"

static NSString * const ArgosAPIBaseURLString = @"http://192.168.1.131:5000/";

@implementation ArgosClient

#pragma mark - Default Argos API client
+ (ArgosClient *)sharedClient {
    static ArgosClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [[NSURL alloc] initWithString:ArgosAPIBaseURLString];
        _sharedClient = [[self alloc] initWithBaseURL:baseUrl];
    });
    
    return _sharedClient;
}

@end
