//
//  DetailView.h
//  Argos
//
//  Created by Francis Tseng on 3/14/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ScrollView.h"
#import "SummaryView.h"
#import "ImageHeaderView.h"
#import "EmbeddedCollectionViewController.h"

@class BaseEntity;

@protocol DetailViewProtocol <UIScrollViewDelegate, SummaryViewDelegate, EmbeddedCollectionViewControllerDelegate>
@end

@interface DetailView : UIView

@property (nonatomic, weak) id <DetailViewProtocol> delegate;
@property (nonatomic, strong) BaseEntity* entity;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) ImageHeaderView *headerView;
@property (nonatomic, strong) ScrollView *scrollView;
@property (nonatomic, assign) float progress;

- (void)setActionButtonTitle:(NSString*)title;
- (void)setHeaderImageViewWithImageUrl:(NSString *)url;

@end
