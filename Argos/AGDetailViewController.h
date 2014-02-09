//
//  AGDetailViewController.h
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGSummaryView.h"
#import "AGSectionHeaderView.h"

@interface AGDetailViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) AGSummaryView *summaryView;

// For keeping track of sticky headers.
@property (strong, nonatomic) AGSectionHeaderView *stuckSectionHeaderView;
@property (nonatomic) CGRect stuckSectionHeaderViewFrame;

- (void)adjustScrollViewHeight;

@end
