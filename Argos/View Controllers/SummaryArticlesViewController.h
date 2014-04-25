//
//  SummaryArticlesViewController.h
//  Argos
//
//  Created by Francis Tseng on 4/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "Event.h"
#import "SummaryView.h"
#import "EmbeddedCollectionViewController.h"

@interface SummaryArticlesViewController : UIViewController <EmbeddedCollectionViewControllerDelegate>

@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) UIScrollView *view;

- (instancetype)initWithEvent:(Event*)event;

@end
