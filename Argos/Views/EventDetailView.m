//
//  EventDetailView.m
//  Argos
//
//  Created by Francis Tseng on 4/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EventDetailView.h"
#import "EventViewCell.h"
#import "EventTabBarController.h"

@interface EventDetailView ()
@property (nonatomic, strong) EventViewCell *cellView;
@end

@implementation EventDetailView

- (id)initWithFrame:(CGRect)frame forEvent:(Event*)event
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.918 green:0.918 blue:0.918 alpha:1.0];
        
        // Scroll view
        self.scrollView = [[ScrollView alloc] initWithFrame:frame verticalOffset:140];
        self.scrollView.scrollEnabled = NO;
        
        // Header view
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame),
                                                                        CGRectGetMinY(frame),
                                                                        CGRectGetWidth(frame),
                                                                        200)];
        _cellView = [[EventViewCell alloc] initWithFrame:CGRectMake(20, 20, CGRectGetWidth(frame) - 40, 100)];
        [self.headerView addSubview:_cellView];
        [self addSubview:self.headerView];
        
        // Progress view
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        self.progressView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), 20);
        self.progressView.tintColor = [UIColor actionColor];
        self.progressView.trackTintColor = [UIColor mutedColor];
        [self.scrollView addSubview:self.progressView];
        
        [self addSubview:self.scrollView];
        [self.scrollView sizeToFit];
        
        self.entity = event;
    }
    return self;
}

- (void)setEntity:(Event *)entity
{
    [super setEntity:entity];
    [_cellView configureCellForEvent:entity];
}

@end