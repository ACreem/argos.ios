//
//  DetailView.h
//  Argos
//
//  Created by Francis Tseng on 3/14/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ScrollView.h"
#import "SummaryView.h"
#import "EmbeddedCollectionViewController.h"

@class BaseEntity;

@protocol DetailViewProtocol <UIScrollViewDelegate, SummaryViewDelegate, EmbeddedCollectionViewControllerDelegate>
@end

@interface DetailView : UIView

@property (nonatomic, weak) id <DetailViewProtocol> delegate;
@property (nonatomic, strong) BaseEntity* entity;
@property (nonatomic, strong) ScrollView *scrollView;
@property (nonatomic, strong) SummaryView *summaryView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) float progress;

@end
