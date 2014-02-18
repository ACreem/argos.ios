//
//  ARDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARDetailViewController.h"
#import "GPUImage.h"
#import <QuartzCore/QuartzCore.h>

@interface ARDetailViewController () {
    CGRect bounds;
    UIView* _gradientView;
    UIImageView* _headerImageViewBlurred;
}

@end

@implementation ARDetailViewController

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
    UIImage* headerImage = [UIImage imageNamed:@"sample"];
    _headerImageView = [[UIImageView alloc] initWithImage:headerImage];
    _headerImageView.frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, headerImageHeight);
    [self.view addSubview:_headerImageView];
    
    // Header image blur
    GPUImageGaussianBlurFilter* filter =[[GPUImageGaussianBlurFilter alloc] init];
    filter.blurRadiusAsFractionOfImageHeight = 0.7;
    filter.blurRadiusAsFractionOfImageWidth = 0.7;
    UIImage* blurred = [filter imageByFilteringImage:headerImage];
    _headerImageViewBlurred = [[UIImageView alloc] initWithImage:blurred];
    _headerImageViewBlurred.frame = _headerImageView.frame;
    _headerImageViewBlurred.alpha = 0.0;
    [self.view addSubview:_headerImageViewBlurred];
    
    // Gradient image overlay
    _gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, headerImageHeight)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _gradientView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], (id)[[UIColor blackColor] CGColor], (id)[[UIColor blackColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [_gradientView.layer insertSublayer:gradient atIndex:0];
    _gradientView.alpha = 0.0;
    [self.view addSubview:_gradientView];
    
    [self.view addSubview:_scrollView];
}

- (void)adjustScrollViewHeight
{
    // Auto size scroll view height.
    // Starting height accomodates for header image spacing.
    float h = 0;
    for (UIView* view in _scrollView.subviews) {
        float fh = view.frame.origin.y + view.frame.size.height;
        h = MAX(h, fh);
    }
    [_scrollView setContentSize:(CGSizeMake(bounds.size.width, h + _headerImageView.frame.size.height))];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Parallax
    float y = scrollView.contentOffset.y;
    CGRect imageFrame = _headerImageView.frame;
    imageFrame.origin.y = -y/6;
    _headerImageView.frame = imageFrame;
    _headerImageViewBlurred.frame = imageFrame;
    
    // Gradient and blur opacity
    _gradientView.alpha = y*1.5/bounds.size.height;
    _headerImageViewBlurred.alpha = y*4/bounds.size.height;
    
    
    // Sticky header
    // Look for the header that needs to be stuck.
    ARSectionHeaderView* selectedHeader;
    for (UIView* header in self.scrollView.subviews) {
        if ([header isKindOfClass:[ARSectionHeaderView class]]) {
            if (y > header.frame.origin.y) {
                selectedHeader = (ARSectionHeaderView*)header;
            }
        }
    }
    
    // If a new header to stick was found, swap it.
    if (selectedHeader) {
        [selectedHeader removeFromSuperview];
        
        // Restore old header to position in UIScrollView
        self.stuckSectionHeaderView.frame = self.stuckSectionHeaderViewFrame;
        [self.stuckSectionHeaderView removeFromSuperview];
        [self.scrollView addSubview:self.stuckSectionHeaderView];
        
        // Setup new header
        CGRect headerFrame = selectedHeader.frame;
        self.stuckSectionHeaderView = selectedHeader;
        self.stuckSectionHeaderViewFrame = headerFrame;
        headerFrame.origin = CGPointMake(0, 0);
        selectedHeader.frame = headerFrame;
        [self.view addSubview:selectedHeader];
        
    // Otherwise, check if it's a header that needs to be removed.
    } else {
        if (y < self.stuckSectionHeaderViewFrame.origin.y) {
            self.stuckSectionHeaderView.frame = self.stuckSectionHeaderViewFrame;
            [self.stuckSectionHeaderView removeFromSuperview];
            [self.scrollView addSubview:self.stuckSectionHeaderView];
        }
    }
}

@end
