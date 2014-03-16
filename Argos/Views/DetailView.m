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
        _scrollView = [[ScrollView alloc] initWithFrame:frame verticalOffset:headerImageHeight];
        
        // Header view
        _headerView = [[ImageHeaderView alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame),
                                                                              CGRectGetMinY(frame),
                                                                              CGRectGetWidth(frame),
                                                                              headerImageHeight)];
        [self addSubview:_headerView];
        
        // Progress view
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progressView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), 20);
        _progressView.tintColor = [UIColor actionColor];
        _progressView.trackTintColor = [UIColor mutedColor];
        [_scrollView addSubview:_progressView];
        
        // Title view
        CGFloat titlePadding = 16.0;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titlePadding,
                                                                    CGRectGetMinY(frame),
                                                                    CGRectGetWidth(frame) - titlePadding*2,
                                                                    CGRectGetHeight(_headerView.bounds))];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont titleFontForSize:20];
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
        
        // Summary view
        CGPoint summaryOrigin = CGPointMake(0, CGRectGetHeight(_headerView.frame));
        _summaryView = [[SummaryView alloc] initWithOrigin:summaryOrigin];
        [_scrollView addSubview:_summaryView];
        
        // Actions view
        CGFloat yPadding = 8.0;
        _actionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _actionButton.titleLabel.font = [UIFont mediumFontForSize:14];
        [_actionButton sizeToFit];
        _actionButton.tintColor = [UIColor actionColor];
        [[_actionButton layer] setBorderWidth:1.0];
        [[_actionButton layer] setBorderColor:[UIColor actionColor].CGColor];
        [[_actionButton layer] setCornerRadius:4.0];
        _actionButton.frame = CGRectMake(CGRectGetWidth(frame)/2 - CGRectGetWidth(_actionButton.frame)/2,
                                             yPadding*2,
                                             CGRectGetWidth(_actionButton.frame) + 20,
                                             CGRectGetHeight(_actionButton.frame));
        
        _actionsView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    CGRectGetMinY(_summaryView.summaryWebView.frame)
                                                                    + CGRectGetHeight(_summaryView.summaryWebView.frame),
                                                                    CGRectGetWidth(frame),
                                                                    CGRectGetHeight(_actionButton.frame)+2*yPadding)];
        [_actionsView addSubview:_actionButton];
        _actionsView.hidden = YES;
        [_summaryView addSubview:_actionsView];
        
        [self addSubview:_scrollView];
        [_scrollView sizeToFit];
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
