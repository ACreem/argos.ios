//
//  ARDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARDetailViewController.h"
#import "BaseEntity.h"

// Sharing/font setting modals.
#import "ShareViewController.h"
#import "FontViewController.h"
#import "TransitionDelegate.h"
#import "UIWindow+FauxStatusBar.h"

// For handling concept links in the summary.
#import "Concept.h"
#import "ConceptDetailViewController.h"

// For sticky headers.
#import "ARCollectionView.h"
#import "ARCollectionHeaderView.h"

// For the mentions pull-out.
#import "IIViewDeckController.h"
#import "MentionsViewController.h"
#import "AppDelegate.h"

// For downloading/processing images.
#import "ImageDownloader.h"
#import <NYXImagesKit/NYXImagesKit.h>

#import "AREmbeddedCollectionViewController.h"


@interface ARDetailViewController ()
// For animated modal transitions with opacity.
@property (nonatomic, strong) TransitionDelegate *transitionController;

// For the progress bar.
@property (nonatomic, assign) int loadedItems;

// For keeping track of sticky headers.
@property (nonatomic, strong) ARCollectionHeaderView *stuckSectionHeaderView;
@property (nonatomic, strong) UIView *stuckSectionHeaderSuperview;
@property (nonatomic, assign) CGRect stuckSectionHeaderViewFrame;
@end

@implementation ARDetailViewController

- (instancetype)initWithEntity:(BaseEntity*)entity
{
    self = [super init];
    if (self) {
        _entity = entity;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hack to get modal view controllers which can have transparent backgrounds.
    // Thx apple.
    self.transitionController = [[TransitionDelegate alloc] init];
    
    // Hack to do back buttons w/o text.
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    self.navigationItem.rightBarButtonItems = [self navigationItems];
    
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.view = [[DetailView alloc] initWithFrame:bounds];
    self.view.delegate = self;
    self.view.entity = self.entity;
    [self loadHeaderImage];
    
    self.loadedItems = 0;
}


- (NSArray*)navigationItems
{
    UIBarButtonItem *paddingItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                          target:nil
                                                                          action:nil];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                 target:self
                                                                                 action:@selector(share:)];
    UIBarButtonItem *fontButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_font"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(font:)];
    
    return @[ shareButton, paddingItem,
              fontButton, paddingItem ];
}

- (void)loadHeaderImage
{
    CGSize headerSize = self.view.headerView.cachedFrame.size;
    
    // Set the header image,
    // downloading if necessary.
    if (self.entity.imageHeader) {
        self.view.image = self.entity.imageHeader;
        
    } else if (self.entity.image) {
        UIImage *headerImage = [self.entity.image scaleToCoverSize:headerSize];
        self.entity.imageHeader = [headerImage cropToSize:headerSize usingMode:NYXCropModeCenter];
        self.view.image = self.entity.imageHeader;
        
    } else if (self.entity.imageUrl) {
        ImageDownloader* imageDownloader = [[ImageDownloader alloc] initWithURL:[NSURL URLWithString:self.entity.imageUrl]];
        [imageDownloader setCompletionHandler:^(UIImage *image) {
            self.entity.image = image;
            UIImage *headerImage = [self.entity.image scaleToCoverSize:headerSize];
            self.entity.imageHeader = [headerImage cropToSize:headerSize usingMode:NYXCropModeCenter];
            self.view.image = self.entity.imageHeader;
        }];
        [imageDownloader startDownload];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Setup the right controller (the mention pane) for the view deck.
    // Doesn't feel quite right for this view controller to reach that far up its hierarchy, but...
    self.navigationController.viewDeckController.rightController = [[MentionsViewController alloc] initWithEntity:self.entity withPredicate:[NSPredicate predicateWithFormat:@"SELF in %@", self.entity.concepts]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Remove the mention pane.
    // For whatever reason, I can't remove it the same way I added it.
    //self.navigationController.viewDeckController.rightController = nil;
    
    // It has to be removed this way, which is messy:
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.deckController.rightController = nil;
    
    [super viewDidDisappear:animated];
}



# pragma mark - Actions
- (void)share:(id)sender
{
    [self presentModalViewController:[[ShareViewController alloc] init]];
}
- (void)font:(id)sender
{
    [self presentModalViewController:[[FontViewController alloc] init]];
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
    [UIWindow hideFauxStatusBar];
    
    // Add the close button.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(screenRect.size.width - 48,
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
        [UIWindow showFauxStatusBar];
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
    CGRect headerFrame = self.view.headerView.frame;
    CGRect titleFrame = self.view.titleLabel.frame;
    
    if (y >= 0) {
        headerFrame.origin.y = -y/6;
        self.view.headerView.frame = headerFrame;
        titleFrame.origin.y = CGRectGetHeight(self.view.headerView.bounds) - CGRectGetHeight(titleFrame) - y/1.4;
        self.view.titleLabel.frame = titleFrame;
        
        // Gradient and blur opacity
        self.view.headerView.gradientView.alpha = y*1.5/CGRectGetHeight(self.view.frame);
        self.view.headerView.blurredImageView.alpha = y*4/CGRectGetHeight(self.view.frame);
        
        // Sticky header
        // Look for the header that needs to be stuck.
        ARCollectionHeaderView* selectedHeader;
        for (UIView* subview in self.view.scrollView.subviews) {
            
            if ([subview isKindOfClass:[ARCollectionView class]]) {
                ARCollectionView* colview = (ARCollectionView*)subview;
                if (y > CGRectGetMinY(subview.frame) && _stuckSectionHeaderView != colview.headerView) {
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
            if (_stuckSectionHeaderSuperview == self.view.scrollView) {
                threshold = CGRectGetMinY(_stuckSectionHeaderViewFrame);
            } else {
                threshold = CGRectGetMinY(_stuckSectionHeaderSuperview.frame);
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
        CGRect frame = CGRectMake(0, y,
                                  CGRectGetWidth(self.view.headerView.cachedFrame) - y,
                                  CGRectGetHeight(self.view.headerView.cachedFrame) - y);
        CGRect titleLabelFrame = self.view.titleLabel.frame;
        
        self.view.headerView.frame = frame;
        titleLabelFrame.origin.y = CGRectGetHeight(self.view.headerView.frame) - CGRectGetHeight(titleLabelFrame);
        self.view.titleLabel.frame = titleLabelFrame;
        
        CGPoint center = CGPointMake(self.view.center.x, self.view.headerView.center.y - y);
        self.view.headerView.center = center;
    }
}


# pragma mark - ARSummaryViewDelegate
- (void)viewConcept:(NSString*)conceptId
{
    NSManagedObjectContext* moc = [[[RKObjectManager sharedManager] managedObjectStore] mainQueueManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Concept" inManagedObjectContext:moc];
    Concept* concept = [[Concept alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:moc];
    [[RKObjectManager sharedManager] getObject:concept
                                          path:[NSString stringWithFormat:@"/entities/%@", conceptId]
                                    parameters:nil
                                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                           [self.navigationController pushViewController:[[ConceptDetailViewController alloc] initWithConcept:concept]
                                                                                animated:YES];
                                       } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                           NSLog(@"failure");
                                       }];
}

# pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        for (AREmbeddedCollectionViewController* ecvc in self.embeddedCollectionViewControllers) {
            [ecvc loadImagesForOnscreenRows];
        }
    }
}

// Fetch a set of entities.
- (void)getEntities:(NSSet*)entities forCollectionView:(ARCollectionViewController*)cvc
{
    __block NSUInteger fetched_concept_count = 0;
    for (BaseEntity* concept in entities) {
        [[RKObjectManager sharedManager] getObject:concept path:concept.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            fetched_concept_count++;
            
            self.loadedItems++;
            self.view.progress = self.loadedItems/self.totalItems;
            
            if (fetched_concept_count == [entities count]) {
                [cvc.collectionView reloadData];
                [cvc.collectionView sizeToFit];
                [self.view.scrollView sizeToFit];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
}

// Get concepts for this entity.
- (void)getConcepts:(NSSet*)concepts
{
    __block NSUInteger fetched_concept_count = 0;
    for (Concept* concept in concepts) {
        [[RKObjectManager sharedManager] getObject:concept path:concept.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            fetched_concept_count++;
            
            self.loadedItems++;
            self.view.progress = self.loadedItems/self.totalItems;
            
            if (fetched_concept_count == [concepts count]) {
                self.view.entity = self.entity;
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
}

@end
