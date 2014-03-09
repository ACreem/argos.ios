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
#import "AREmbeddedCollectionViewController.h"

@interface ARDetailViewController : UIViewController <UIScrollViewDelegate, ARSummaryViewDelegate>

@property (strong, nonatomic) ARScrollView *scrollView;
@property (strong, nonatomic) ARSummaryView *summaryView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) NSString *viewTitle;

// Progress
@property (strong, nonatomic) UIProgressView *progressView;
@property (assign, nonatomic) int loadedItems;
@property (assign, nonatomic) int totalItems;

- (void)viewEntity:(NSString*)entityId;
- (void)setHeaderImage:(UIImage*)image;
- (void)setHeaderImageForEntity:(id<AREntity>)entity;

@end
