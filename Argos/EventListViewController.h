//
//  EventListViewController.h
//  Argos
//
//  Created by Francis Tseng on 1/27/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"
#import "EGORefreshTableHeaderView.h"

@interface EventListViewController : UITableViewController <EGORefreshTableHeaderDelegate>

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@property (strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property (strong, nonatomic) NSDate* dateLastUpdated;
@property (assign, nonatomic) BOOL reloading;

@end
