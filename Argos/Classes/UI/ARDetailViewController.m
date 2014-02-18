//
//  ARDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARDetailViewController.h"
#import "ARSectionHeaderView.h"
#import "AREmbeddedTableView.h"
#import "GPUImage.h"
#import <QuartzCore/QuartzCore.h>
#import "Entity.h"
#import "EntityDetailViewController.h"

@interface ARDetailViewController () {
    CGRect _bounds;
    
    // For image scrolling effects.
    UIView* _gradientView;
    UIImageView* _headerImageViewBlurred;
    UIImageView* _headerImageView;
    
    // For keeping track of sticky headers.
    ARSectionHeaderView *_stuckSectionHeaderView;
    UIView *_stuckSectionHeaderSuperview;
    CGRect _stuckSectionHeaderViewFrame;
}

@end

@implementation ARDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hack to do back buttons w/o text.
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
    // Share button.
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    float headerImageHeight = 220.0;
    _bounds = [[UIScreen mainScreen] bounds];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Scroll view
    _scrollView = [[ARScrollView alloc] initWithFrame:CGRectMake(_bounds.origin.x, _bounds.origin.y, _bounds.size.width, _bounds.size.height) verticalOffset:headerImageHeight];
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(_bounds.origin.x, _bounds.origin.y, _bounds.size.width, headerImageHeight)];
    
    // Header image
    UIImage* headerImage = [UIImage imageNamed:@"sample"];
    _headerImageView = [[UIImageView alloc] initWithImage:headerImage];
    _headerImageView.frame = CGRectMake(_bounds.origin.x, _bounds.origin.y, _bounds.size.width, headerImageHeight);
    [_headerView addSubview:_headerImageView];
    
    // Header image blur
    GPUImageGaussianBlurFilter* filter =[[GPUImageGaussianBlurFilter alloc] init];
    filter.blurRadiusAsFractionOfImageHeight = 0.7;
    filter.blurRadiusAsFractionOfImageWidth = 0.7;
    UIImage* blurred = [filter imageByFilteringImage:headerImage];
    _headerImageViewBlurred = [[UIImageView alloc] initWithImage:blurred];
    _headerImageViewBlurred.frame = _headerImageView.frame;
    _headerImageViewBlurred.alpha = 0.0;
    [_headerView addSubview:_headerImageViewBlurred];
    
    // Text gradient (so the text is readable)
    UIView *textGradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bounds.size.width, headerImageHeight)];
    CAGradientLayer *textGradient = [CAGradientLayer layer];
    textGradient.frame = textGradientView.bounds;
    textGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [textGradientView.layer insertSublayer:textGradient atIndex:0];
    textGradientView.alpha = 0.4;
    [_headerView addSubview:textGradientView];
    
    // Gradient image overlay (for scrolling)
    _gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bounds.size.width, headerImageHeight)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _gradientView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], (id)[[UIColor blackColor] CGColor], (id)[[UIColor blackColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [_gradientView.layer insertSublayer:gradient atIndex:0];
    _gradientView.alpha = 0.0;
    [_headerView addSubview:_gradientView];
    
    [self.view addSubview:_headerView];
    [self.view addSubview:_scrollView];
}

- (void) setupTitle
{
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, _bounds.origin.y, _bounds.size.width - 32.0, self.headerView.bounds.size.height)];
    titleLabel.text = _viewTitle;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"KlinicSlab-Book" size:20];
    titleLabel.numberOfLines = 0;
    [titleLabel sizeToFit];
    CGRect titleFrame = titleLabel.frame;
    titleFrame.size.height += 20.0;
    titleFrame.origin.y = self.headerView.bounds.size.height - titleFrame.size.height;
    titleLabel.frame = titleFrame;
    [self.scrollView addSubview:titleLabel];
}

- (NSString*)processSummary:(NSString*)summaryText withEntities:(NSSet*)entities
{
    // Entities are sorted by length (longest first) so when replacing them in the summary text,
    // the larger names are captured first. Then names are replaced taking into account their spaces.
    // Combined, this avoids situations with nested `a` tags.
    // For instance, "UN Convention" might become "<a href='#'><a href='#'>UN</a> Convention</a>".
    // Instead, " UN Convention" as a whole is captured: "<a href='#'>UN Convention</a>",
    // and then " UN" can't be captured since it has no space on the left anymore.
    NSArray* sortedEntities = [[entities allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *first = [NSNumber numberWithInt:[[(Entity*)obj1 name] length]];
        NSNumber *second = [NSNumber numberWithInt:[[(Entity*)obj2 name] length]];
        return [first compare:second];
    }];
    
    for (Entity* entity in sortedEntities) {
        summaryText = [summaryText stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@" %@", entity.name] withString:[NSString stringWithFormat:@" <a href='#' onclick='objc(\"%@\");'>%@</a>", entity.entityId, entity.name]];
    }
    return summaryText;
}

# pragma mark - Actions
- (void)share:(id)sender
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Parallax
    float y = scrollView.contentOffset.y;
    CGRect imageFrame = _headerImageView.frame;
    imageFrame.origin.y = -y/6;
    _headerView.frame = imageFrame;
    
    // Gradient and blur opacity
    _gradientView.alpha = y*1.5/_bounds.size.height;
    _headerImageViewBlurred.alpha = y*4/_bounds.size.height;
    
    // Sticky header
    // Look for the header that needs to be stuck.
    ARSectionHeaderView* selectedHeader;
    for (UIView* subview in self.scrollView.subviews) {
        
        // Check if this is a top-level header view.
        if ([subview isKindOfClass:[ARSectionHeaderView class]]) {
            if (y > subview.frame.origin.y) {
                selectedHeader = (ARSectionHeaderView*)subview;
            }
            
        // Check if this is an AREmbeddedTableView, which has a header view within it.
        } else if ([subview isKindOfClass:[AREmbeddedTableView class]]) {
            AREmbeddedTableView* embeddedTableView = (AREmbeddedTableView*)subview;
            if (y > subview.frame.origin.y) {
                selectedHeader = embeddedTableView.headerView;
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
        }
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
