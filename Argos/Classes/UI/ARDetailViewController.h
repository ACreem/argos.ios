//
//  ARDetailViewController.h
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARSummaryView.h"
#import "ARScrollView.h"

@interface ARDetailViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) ARScrollView *scrollView;
@property (strong, nonatomic) ARSummaryView *summaryView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) NSString *viewTitle;

- (void) setupTitle;
- (NSString*)processSummary:(NSString*)summaryText withEntities:(NSSet*)entities;


@end
