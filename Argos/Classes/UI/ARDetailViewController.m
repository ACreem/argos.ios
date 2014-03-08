//
//  ARDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARDetailViewController.h"

#import "ARShareViewController.h"
#import "ARFontViewController.h"

#import "Entity.h"
#import "EntityDetailViewController.h"

#import "ARCollectionView.h"
#import "ARCollectionHeaderView.h"

#import "ImageDownloader.h"

#import "TransitionDelegate.h"

#import <QuartzCore/QuartzCore.h>

@interface ARDetailViewController () {
    CGRect _bounds;
    
    // For image scrolling effects.
    UIView *_gradientView;
    UIView *_textGradientView;
    UIImageView *_headerImageViewBlurred;
    UIImageView *_headerImageView;
    UILabel *_titleLabel;
    CGRect _cachedImageFrame;
    
    // For keeping track of sticky headers.
    ARCollectionHeaderView *_stuckSectionHeaderView;
    UIView *_stuckSectionHeaderSuperview;
    CGRect _stuckSectionHeaderViewFrame;
    
    ARShareViewController *_shareViewController;
    ARFontViewController *_fontViewController;
}

@property (nonatomic, strong) TransitionDelegate *transitionController;

@end

@implementation ARDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hack to get modal view controllers which can have transparent backgrounds.
    // Thx apple.
    self.transitionController = [[TransitionDelegate alloc] init];
    
    // Hack to do back buttons w/o text.
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
    // Navigation buttons.
    // (Padding)
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                          target:nil
                                                                          action:nil];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    UIBarButtonItem *fontButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_font"] style:UIBarButtonItemStylePlain target:self action:@selector(font:)];
    
    UIBarButtonItem *watchButton;
    if (self.isWatching) {
        watchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_watched"] style:UIBarButtonItemStylePlain target:self action:@selector(watch:)];
        watchButton.tag = 1;
    } else {
        watchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_watch"] style:UIBarButtonItemStylePlain target:self action:@selector(watch:)];
        watchButton.tag = 0;
    }
    
    UIBarButtonItem *bookmarkButton;
    if (self.isBookmarked) {
        bookmarkButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_bookmarked"] style:UIBarButtonItemStylePlain target:self action:@selector(bookmark:)];
        bookmarkButton.tag = 1;
    } else {
        bookmarkButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_bookmark"] style:UIBarButtonItemStylePlain target:self action:@selector(bookmark:)];
        bookmarkButton.tag = 0;
    }
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:shareButton, item, bookmarkButton, item, fontButton, item, watchButton, item, nil];
    
    
    float headerImageHeight = 200.0;
    _bounds = [[UIScreen mainScreen] bounds];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Scroll view
    _scrollView = [[ARScrollView alloc] initWithFrame:_bounds verticalOffset:headerImageHeight];
    //_scrollView.bounces = NO;
    _scrollView.delegate = self;
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(_bounds.origin.x, _bounds.origin.y, _bounds.size.width, headerImageHeight)];
    
    // Header image
    UIImage* headerImage = [UIImage imageNamed:@"placeholder"];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageView = [[UIImageView alloc] initWithImage:headerImage];
    _headerImageView.frame = CGRectMake(_bounds.origin.x, _bounds.origin.y, _bounds.size.width, headerImageHeight);
    _cachedImageFrame = _headerImageView.frame;
    [_headerView addSubview:_headerImageView];
    
    // Header image blur
    UIImage* blurred = [headerImage gaussianBlurWithBias:0];
    _headerImageViewBlurred = [[UIImageView alloc] initWithImage:blurred];
    _headerImageViewBlurred.frame = _headerImageView.frame;
    _headerImageViewBlurred.alpha = 0.0;
    [_headerView addSubview:_headerImageViewBlurred];
    
    // Text gradient (so the text is readable)
    _textGradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bounds.size.width, headerImageHeight)];
    _textGradientView.contentMode = UIViewContentModeScaleAspectFill;
    CAGradientLayer *textGradient = [CAGradientLayer layer];
    textGradient.frame = _textGradientView.bounds;
    textGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [_textGradientView.layer insertSublayer:textGradient atIndex:0];
    _textGradientView.alpha = 0.6;
    [_headerView addSubview:_textGradientView];
    
    // Gradient image overlay (for scrolling)
    _gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bounds.size.width, headerImageHeight)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _gradientView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], (id)[[UIColor blackColor] CGColor], (id)[[UIColor blackColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [_gradientView.layer insertSublayer:gradient atIndex:0];
    _gradientView.alpha = 0.0;
    [_headerView addSubview:_gradientView];
    
    [self.view addSubview:_headerView];
    
    _loadedItems = 0;
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    _progressView.frame = CGRectMake(0, 0, _bounds.size.width, 20);
    _progressView.tintColor = [UIColor actionColor];
    _progressView.trackTintColor = [UIColor mutedColor];
    [_scrollView addSubview:_progressView];
    
    [self setupTitle];
    
    [self.view addSubview:_scrollView];
}

- (void)setupTitle
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, _bounds.origin.y, _bounds.size.width - 32.0, self.headerView.bounds.size.height)];
    _titleLabel.text = _viewTitle;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont titleFontForSize:20];
    _titleLabel.numberOfLines = 0;
    [_titleLabel sizeToFit];
    CGRect titleFrame = _titleLabel.frame;
    titleFrame.size.height += 20.0;
    titleFrame.origin.y = self.headerView.bounds.size.height - titleFrame.size.height;
    _titleLabel.frame = titleFrame;
    [self.view addSubview:_titleLabel];
}

- (void)setHeaderImage:(UIImage*)image
{
    UIImage *croppedImage = [image scaleToFitSize:CGSizeMake(640, 400)];
    croppedImage = [image cropToSize:CGSizeMake(640, 400) usingMode:NYXCropModeCenter];
    [_headerImageView setImage:croppedImage];
    
    UIImage* blurred = [croppedImage gaussianBlurWithBias:0];
    [_headerImageViewBlurred setImage:blurred];
}

- (void)setHeaderImageForEntity:(id<Entity>)entity
{
    // Set the header image,
    // downloading if necessary.
    if (entity.image) {
        [self setHeaderImage:entity.image];
    } else if (entity.imageUrl) {
        ImageDownloader* imageDownloader = [[ImageDownloader alloc] initWithURL:[NSURL URLWithString:entity.imageUrl]];
        NSLog(@"%@", entity.imageUrl);
        [imageDownloader setCompletionHandler:^(UIImage *image) {
            NSLog(@"COMPLETED COMPLETED");
            entity.image = image;
            [self setHeaderImage:entity.image];
        }];
        [imageDownloader startDownload];
    }
}



# pragma mark - Actions
- (void)share:(id)sender
{
    _shareViewController = [[ARShareViewController alloc] init];
    [self presentModalViewController:_shareViewController];
}
- (void)font:(id)sender
{
    _fontViewController = [[ARFontViewController alloc] init];
    [self presentModalViewController:_fontViewController];
}
- (void)bookmark:(id)sender
{
    NSLog(@"bookmarked");
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    if (button.tag != 1) {
        button.image = [UIImage imageNamed:@"nav_bookmarked"];
        [button setTag:1];
    } else {
        button.image = [UIImage imageNamed:@"nav_bookmark"];
        [button setTag:0];
    }
}
- (void)watch:(id)sender
{
    NSLog(@"watched");
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    if (button.tag != 1) {
        button.image = [UIImage imageNamed:@"nav_watched"];
        [button setTag:1];
    } else {
        button.image = [UIImage imageNamed:@"nav_watch"];
        [button setTag:0];
    }
}


# pragma mark - UIViewController
// Helper for consistently presenting modal view controllers.
- (void)presentModalViewController:(UIViewController*)viewControllerToPresent
{
    // Set transparent background.
    viewControllerToPresent.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
    
    // Hack to get transparent backgrounds to be respected.
    [viewControllerToPresent setTransitioningDelegate:self.transitionController];
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
    
    // Have to hide our fake status bar at the top, or else it overlays everything.
    [[[UIApplication sharedApplication] keyWindow] viewWithTag:kFauxStatusBarTag].hidden = YES;
    
    
    // Add the close button.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(
                                                                       screenRect.size.width - 48,
                                                                       [UIApplication sharedApplication].statusBarFrame.size.height,
                                                                       48, 48)];
    [closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeModal:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewControllerToPresent.view addSubview:closeButton];
    
    [super presentViewController:viewControllerToPresent animated:YES completion:nil];
}
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:^{
        // Have to re-show our fake status bar at the top.
        [[[UIApplication sharedApplication] keyWindow] viewWithTag:kFauxStatusBarTag].hidden = NO;
    }];
}
- (void)closeModal:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Parallax
    float y = scrollView.contentOffset.y;
    CGRect imageFrame = _headerImageView.frame;
    CGRect titleFrame = _titleLabel.frame;
    
    if (y >= 0) {
        imageFrame.origin.y = -y/6;
        _headerView.frame = imageFrame;
        titleFrame.origin.y = self.headerView.bounds.size.height - titleFrame.size.height - y/1.4;
        _titleLabel.frame = titleFrame;
        
        // Gradient and blur opacity
        _gradientView.alpha = y*1.5/_bounds.size.height;
        _headerImageViewBlurred.alpha = y*4/_bounds.size.height;
        
        // Sticky header
        // Look for the header that needs to be stuck.
        ARCollectionHeaderView* selectedHeader;
        for (UIView* subview in self.scrollView.subviews) {
            
            if ([subview isKindOfClass:[ARCollectionView class]]) {
                ARCollectionView* colview = (ARCollectionView*)subview;
                if (y > subview.frame.origin.y && _stuckSectionHeaderView != colview.headerView) {
                    selectedHeader = colview.headerView;
                }
            }
        }
        
        // If a new header to stick was found, swap it.
        if (selectedHeader) {
            
            // Restore old header to position in UIScrollView
            if (_stuckSectionHeaderView) {
                _stuckSectionHeaderView.frame = _stuckSectionHeaderViewFrame;
                [_stuckSectionHeaderView removeFromSuperview];
                [_stuckSectionHeaderSuperview addSubview:_stuckSectionHeaderView];
                
                [UIView animateWithDuration:0.2 animations:^{
                    _stuckSectionHeaderView.backgroundColor = [UIColor whiteColor];
                    _stuckSectionHeaderView.titleLabel.textColor = [UIColor lightGrayColor];
                }];
            }
            
            // Setup new header
            // We need to keep track of:
            //  - the header view itself
            //  - the header view's superview (which could be the scroll view itself)
            //  - the original frame of the header view
            CGRect headerFrame = selectedHeader.frame;
            _stuckSectionHeaderView = selectedHeader;
            _stuckSectionHeaderViewFrame = headerFrame;
            _stuckSectionHeaderSuperview = selectedHeader.superview;
            
            // Remove the new header from its original superview.
            [selectedHeader removeFromSuperview];
            
            // Set up its frame to be placed at the top,
            // then add it to the main view.
            headerFrame.origin = CGPointMake(0, 0);
            selectedHeader.frame = headerFrame;
            [self.view addSubview:selectedHeader];
            
            [UIView animateWithDuration:0.2 animations:^{
                selectedHeader.backgroundColor = [UIColor secondaryColor];
                selectedHeader.titleLabel.textColor = [UIColor whiteColor];
            }];
            
        // Otherwise, check if it's a header that needs to be removed.
        } else {
            // Check if the stuck header view has scrolled off.
            // If it's superview is the scroll view itself, it needs
            // to be checked relative to its own original frame,
            // otherwise it needs to be checked relative to its original
            // superview's frame.
            float threshold;
            if (_stuckSectionHeaderSuperview == self.scrollView) {
                threshold = _stuckSectionHeaderViewFrame.origin.y;
            } else {
                threshold = _stuckSectionHeaderSuperview.frame.origin.y;
            }
            if (y < threshold) {
                _stuckSectionHeaderView.frame = _stuckSectionHeaderViewFrame;
                [_stuckSectionHeaderView removeFromSuperview];
                [_stuckSectionHeaderSuperview addSubview:_stuckSectionHeaderView];
                
                [UIView animateWithDuration:0.2 animations:^{
                    _stuckSectionHeaderView.backgroundColor = [UIColor whiteColor];
                    _stuckSectionHeaderView.titleLabel.textColor = [UIColor lightGrayColor];
                }];
                
                _stuckSectionHeaderView = nil;
            }
        }
    } else {
        
        // Stretchy header
        CGRect frame = CGRectMake(0, y, _cachedImageFrame.size.width-y, _cachedImageFrame.size.height-y);
        CGRect textGradientFrame = _textGradientView.frame;
        CGRect titleLabelFrame = _titleLabel.frame;
        
        _headerImageView.frame = frame;
        textGradientFrame.size.height = _headerImageView.frame.size.height;
        textGradientFrame.origin.y = -y;
        titleLabelFrame.origin.y = _headerImageView.frame.size.height - titleLabelFrame.size.height;
        _textGradientView.frame = textGradientFrame;
        _titleLabel.frame = titleLabelFrame;
        
        CGPoint center = CGPointMake(self.view.center.x, _headerImageView.center.y - y);
        _headerImageView.center = center;
    }
}


# pragma mark - ARSummaryViewDelegate
- (void)viewEntity:(NSString*)entityId
{
    NSManagedObjectContext* moc = [[[RKObjectManager sharedManager] managedObjectStore] mainQueueManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:moc];
    Entity* entity = [[Entity alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:moc];
    [[RKObjectManager sharedManager] getObject:entity path:[NSString stringWithFormat:@"/entities/%@", entityId] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self.navigationController pushViewController:[[EntityDetailViewController alloc] initWithEntity:entity] animated:YES];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];
}

@end
