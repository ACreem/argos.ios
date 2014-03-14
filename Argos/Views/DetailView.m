//
//  DetailView.m
//  Argos
//
//  Created by Francis Tseng on 3/14/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "DetailView.h"
#import "BaseEntity.h"
#import "ARGalleryViewController.h"
#import "ARSummaryView.h"

@interface DetailView ()
@property (nonatomic, strong) ARSummaryView *summaryView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIView *actionsView;
@end

@implementation DetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat headerImageHeight = 200.0;
        self.backgroundColor = [UIColor whiteColor];
        
        // Scroll view
        self.scrollView = [[ARScrollView alloc] initWithFrame:frame verticalOffset:headerImageHeight];
        
        // Header view
        self.headerView = [[ARImageHeaderView alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame),
                                                                              CGRectGetMinY(frame),
                                                                              CGRectGetWidth(frame),
                                                                              headerImageHeight)];
        [self addSubview:self.headerView];
        
        // Progress view
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        self.progressView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), 20);
        self.progressView.tintColor = [UIColor actionColor];
        self.progressView.trackTintColor = [UIColor mutedColor];
        [self.scrollView addSubview:self.progressView];
        
        // Title view
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0,
                                                                    CGRectGetMinY(frame),
                                                                    CGRectGetWidth(frame) - 32.0,
                                                                    CGRectGetHeight(self.headerView.frame))];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont titleFontForSize:20];
        self.titleLabel.numberOfLines = 0;
        [self.titleLabel sizeToFit];
        CGRect titleFrame = self.titleLabel.frame;
        titleFrame.size.height += 20.0;
        titleFrame.origin.y = CGRectGetHeight(self.headerView.frame) - CGRectGetHeight(titleFrame);
        self.titleLabel.frame = titleFrame;
        [self addSubview:self.titleLabel];
        
        // Summary view
        CGPoint summaryOrigin = CGPointMake(0, CGRectGetHeight(self.headerView.frame));
        self.summaryView = [[ARSummaryView alloc] initWithOrigin:summaryOrigin];
        [self.scrollView addSubview:self.summaryView];
        
        // Actions view
        CGFloat textPaddingVertical = 8.0;
        self.actionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.actionButton.titleLabel.font = [UIFont mediumFontForSize:14];
        [self.actionButton sizeToFit];
        self.actionButton.frame = CGRectMake(0, 0,
                                       CGRectGetWidth(self.actionButton.frame) + 20,
                                       CGRectGetHeight(self.actionButton.frame));
        self.actionButton.tintColor = [UIColor actionColor];
        [[self.actionButton layer] setBorderWidth:1.0];
        [[self.actionButton layer] setBorderColor:[UIColor actionColor].CGColor];
        [[self.actionButton layer] setCornerRadius:4.0];
        CGRect buttonFrame = self.actionButton.frame;
        buttonFrame.origin.x = CGRectGetWidth(frame)/2 - CGRectGetWidth(self.actionButton.frame)/2;
        buttonFrame.origin.y = textPaddingVertical*2;
        self.actionButton.frame = buttonFrame;
        
        self.actionsView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    CGRectGetMinY(self.summaryView.summaryWebView.frame)
                                                                    + CGRectGetHeight(self.summaryView.summaryWebView.frame),
                                                                    CGRectGetWidth(frame),
                                                                    CGRectGetHeight(self.actionButton.frame)+2*textPaddingVertical)];
        self.actionsView.hidden = YES;
        [self.summaryView addSubview:self.actionsView];
        
        [self addSubview:self.scrollView];
        [self.scrollView sizeToFit];
    }
    return self;
}

- (void)setEntity:(BaseEntity *)entity
{
    _entity = entity;
    self.titleLabel.text = entity.title;
    self.image = entity.imageHeader;
    self.summaryView.entity = entity;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self.headerView setImage:image];
}

- (void)setDelegate:(id <DetailViewProtocol>)delegate
{
    _delegate = delegate;
    self.scrollView.delegate = delegate;
    self.summaryView.delegate = delegate;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    [self.progressView setProgress:progress animated:YES];
}

- (void)setActionButtonTitle:(NSString*)title
{
    self.actionsView.hidden = NO;
    [self.actionButton setTitle:title forState:UIControlStateNormal];
    [self.actionButton sizeToFit];
    [self.scrollView sizeToFit];
}

@end
