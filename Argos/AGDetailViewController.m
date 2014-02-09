//
//  AGDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "AGDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AGDetailViewController () {
    CGRect bounds;
    UIView *_gradientView;
}

@end

@implementation AGDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hack to do back buttons w/o text.
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain target:nil action:nil];
    
    float headerImageHeight = 220.0;
    bounds = [[UIScreen mainScreen] bounds];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Scroll view
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height)];
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    
    // Header image
    _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sample"]];
    _headerImageView.frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, headerImageHeight);
    [self.view addSubview:_headerImageView];
    
    // Gradient image overlay
    _gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, headerImageHeight)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _gradientView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], (id)[[UIColor blackColor] CGColor], (id)[[UIColor blackColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [_gradientView.layer insertSublayer:gradient atIndex:0];
    _gradientView.alpha = 0.0;
    [_headerImageView addSubview:_gradientView];
    
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

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Parallax
    float y = scrollView.contentOffset.y;
    CGRect imageFrame = _headerImageView.frame;
    imageFrame.origin.y = -y/6;
    _headerImageView.frame = imageFrame;
    
    // Gradient opacity
    _gradientView.alpha = y*1.5/bounds.size.height;
}

@end
