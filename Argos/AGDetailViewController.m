//
//  AGDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "AGDetailViewController.h"

@interface AGDetailViewController () {
    CGRect bounds;
}

@end

@implementation AGDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float headerImageHeight = 220.0;
    bounds = [[UIScreen mainScreen] bounds];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Scroll view
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height)];
    _scrollView.bounces = NO;
    
    // Header image
    _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sample"]];
    _headerImageView.frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, headerImageHeight);
    [self.view addSubview:_headerImageView];
    
    [self.view addSubview:_scrollView];
}


- (void)adjustScrollViewHeight
{
    // Auto size scroll view height.
    // Starting height accomodates for header image spacing.
    CGFloat scrollViewHeight = _headerImageView.bounds.size.height;
    for (UIView* view in _scrollView.subviews) {
        scrollViewHeight += view.frame.size.height;
    }
    [_scrollView setContentSize:(CGSizeMake(bounds.size.width, scrollViewHeight))];
}

@end
