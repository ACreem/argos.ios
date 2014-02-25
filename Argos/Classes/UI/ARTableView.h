//
//  ARTableView.h
//  Argos
//
//  Created by Francis Tseng on 2/23/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARSectionHeaderView.h"

@interface ARTableView : UITableView

@property (strong, nonatomic) ARSectionHeaderView *headerView;

@end
