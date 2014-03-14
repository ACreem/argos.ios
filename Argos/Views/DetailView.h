//
//  DetailView.h
//  Argos
//
//  Created by Francis Tseng on 3/14/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARScrollView.h"
#import "ARSummaryView.h"
#import "ARImageHeaderView.h"
#import "AREmbeddedCollectionViewController.h"

@class BaseEntity;

@protocol DetailViewProtocol <UIScrollViewDelegate, ARSummaryViewDelegate, AREmbeddedCollectionViewControllerDelegate>
@end

@interface DetailView : UIView

@property (nonatomic, weak) id <DetailViewProtocol> delegate;
@property (nonatomic, strong) BaseEntity* entity;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) ARImageHeaderView *headerView;
@property (nonatomic, strong) ARScrollView *scrollView;
@property (nonatomic, assign) float progress;

- (void)setActionButtonTitle:(NSString*)title;

@end
