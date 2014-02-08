//
//  ArgosClient.h
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@interface ArgosClient : AFHTTPRequestOperationManager

+ (ArgosClient *)sharedClient;

@end
