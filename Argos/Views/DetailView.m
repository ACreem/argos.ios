//
//  DetailView.m
//  Argos
//
//  Created by Francis Tseng on 3/14/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "DetailView.h"
#import "BaseEntity.h"
#import "GalleryViewController.h"
#import "SummaryView.h"

@interface DetailView ()
@property (nonatomic, strong) SummaryView *summaryView;
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
        self.scrollView = [[ScrollView alloc] initWithFrame:frame verticalOffset:headerImageHeight];
        
        // Header view
        self.headerView = [[ImageHeaderView alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame),
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
        CGFloat titlePadding = 16.0;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titlePadding,
                                                                    CGRectGetMinY(frame),
                                                                    CGRectGetWidth(frame) - titlePadding*2,
                                                                    CGRectGetHeight(self.headerView.bounds))];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont titleFontForSize:20];
        self.titleLabel.numberOfLines = 0;
        [self addSubview:self.titleLabel];
        
        // Summary view
        CGPoint summaryOrigin = CGPointMake(0, CGRectGetHeight(self.headerView.frame));
        self.summaryView = [[SummaryView alloc] initWithOrigin:summaryOrigin];
        [self.scrollView addSubview:self.summaryView];
        
        // Actions view
        CGFloat yPadding = 8.0;
        self.actionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.actionButton.titleLabel.font = [UIFont mediumFontForSize:14];
        [self.actionButton sizeToFit];
        self.actionButton.tintColor = [UIColor actionColor];
        [[self.actionButton layer] setBorderWidth:1.0];
        [[self.actionButton layer] setBorderColor:[UIColor actionColor].CGColor];
        [[self.actionButton layer] setCornerRadius:4.0];
        self.actionButton.frame = CGRectMake(CGRectGetWidth(frame)/2 - CGRectGetWidth(self.actionButton.frame)/2,
                                             yPadding*2,
                                             CGRectGetWidth(self.actionButton.frame) + 20,
                                             CGRectGetHeight(self.actionButton.frame));
        
        self.actionsView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    CGRectGetMinY(self.summaryView.summaryWebView.frame)
                                                                    + CGRectGetHeight(self.summaryView.summaryWebView.frame),
                                                                    CGRectGetWidth(frame),
                                                                    CGRectGetHeight(self.actionButton.frame)+2*yPadding)];
        [self.actionsView addSubview:self.actionButton];
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
    self.summaryView.entity = entity;
    
    // Reposition the title label.
    [self.titleLabel sizeToFit];
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.size.height += 20.0;
    titleFrame.origin.y = CGRectGetHeight(self.headerView.bounds) - CGRectGetHeight(titleFrame);
    self.titleLabel.frame = titleFrame;
    
    // Because setting the header image is
    // somewhat expensive (involves blurring
    // of the image), it must be explicitly
    // set separately (with -setImage:)
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
    
    // Reposition the button.
    CGRect frame = self.actionButton.frame;
    CGFloat xPadding = 20;
    frame.origin.x = CGRectGetWidth(self.actionsView.frame)/2 - (CGRectGetWidth(self.actionButton.frame) + xPadding)/2;
    frame.size.width = CGRectGetWidth(self.actionButton.frame) + xPadding;
    self.actionButton.frame = frame;
    
    [self.scrollView sizeToFit];
}

@end
