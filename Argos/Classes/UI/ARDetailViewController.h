//
//  ARDetailViewController.h
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARSummaryView.h"
#import "ARSectionHeaderView.h"

@interface ARDetailViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) ARSummaryView *summaryView;

// For keeping track of sticky headers.
@property (strong, nonatomic) ARSectionHeaderView *stuckSectionHeaderView;
@property (nonatomic) CGRect stuckSectionHeaderViewFrame;

- (void)adjustScrollViewHeight;

@end
