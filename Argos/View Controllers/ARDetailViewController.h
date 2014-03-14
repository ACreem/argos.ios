//
//  ARDetailViewController.h
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//
//  ============================================================
//  Abstract super class for detail view controllers. It mainly
//  consists of a header image and a summary view, though its
//  subclasses will likely have additional elements such as
//  embedded collection views or gallery views.
//  It also consists of a progress bar though its subclasses are
//  expected to implement the bar's actual loading.
//  This view controller also sets up its navigation bar; the
//  items in the navigation bar are configurable by subclasses.
//  It also handles its presentation of modal view controllers.
//  ============================================================

#import "ARSummaryView.h"
#import "ARScrollView.h"
#import "ARHeaderView.h"
#import "AREmbeddedCollectionViewController.h"

@interface ARDetailViewController : UIViewController <UIScrollViewDelegate, ARSummaryViewDelegate>

@property (nonatomic, strong) ARScrollView *scrollView;
@property (nonatomic, strong) ARSummaryView *summaryView;
@property (nonatomic, strong) ARHeaderView *headerView;
@property (nonatomic, strong) NSString *viewTitle;

// Progress
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) int loadedItems;
@property (nonatomic, assign) int totalItems;

- (void)viewEntity:(NSString*)entityId;
- (void)setHeaderImageForEntity:(id<AREntity>)entity;

@end
