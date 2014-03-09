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
- (void)setHeaderImageForEntity:(id<Entity>)entity;

@end
