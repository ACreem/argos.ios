//
//  DetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "DetailViewController.h"
#import "BaseEntity+Concepts.h"

// Sharing/font setting modals.
#import "ShareViewController.h"
#import "FontViewController.h"
#import "TransitionDelegate.h"
#import "UIWindow+FauxStatusBar.h"

// For handling concept links in the summary.
#import "Concept.h"
#import "ConceptDetailViewController.h"

// For sticky headers.
#import "CollectionView.h"
#import "CollectionHeaderView.h"

// For the mentions pull-out.
#import "IIViewDeckController.h"
#import "MentionsViewController.h"
#import "AppDelegate.h"

// For downloading/processing images.
#import "ImageDownloader.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "EmbeddedCollectionViewController.h"
//#import "GalleryViewController.h"


@interface DetailViewController ()
// For animated modal transitions with opacity.
@property (nonatomic, strong) TransitionDelegate *transitionController;

// For the progress bar.
@property (nonatomic, assign) int loadedItems;

// For keeping track of sticky headers.
@property (nonatomic, strong) CollectionHeaderView *stuckSectionHeaderView;
@property (nonatomic, strong) UIView *stuckSectionHeaderSuperview;
@property (nonatomic, assign) CGRect stuckSectionHeaderViewFrame;
@end

@implementation DetailViewController

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
    
    self.loadedItems = 0;
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.view = [[DetailView alloc] initWithFrame:bounds];
    self.view.delegate = self;
    self.view.entity = self.entity;
    
    // not all detail views have header images now
    //[self.view.headerView setHeaderImageViewWithImageUrl:self.entity.imageUrl];
    
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


# pragma mark - Setup
- (NSArray*)navigationItems
{
    UIBarButtonItem *paddingItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:nil
                                                                                 action:nil];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                 target:self
                                                                                 action:@selector(share:)];
    
    return @[ shareButton, paddingItem ];
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


# pragma mark - SummaryViewDelegate
- (void)viewConcept:(NSString*)conceptId
{
    // First try to find an existing concept by this id.
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Concept"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"conceptId == %@", conceptId];
    NSError *error = nil;
    [fetchRequest setPredicate:predicate];
    NSManagedObjectContext* moc = [[[RKObjectManager sharedManager] managedObjectStore] mainQueueManagedObjectContext];
    NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
    
    Concept *concept = nil;
    if (results.count > 0) {
        concept = [results firstObject];
        
    // If none is found, create a new one.
    } else {
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Concept" inManagedObjectContext:moc];
        concept = [[Concept alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:moc];
        concept.conceptId = conceptId;
    }
    [self.navigationController pushViewController:[[ConceptDetailViewController alloc] initWithConcept:concept]
                                         animated:YES];
}


# pragma mark - Data getting
// Fetch a set of entities.
- (void)getEntities:(NSSet*)entities forCollectionView:(CollectionViewController*)cvc
{
    __block NSUInteger fetched_entity_count = 0;
    for (BaseEntity* entity in entities) {
        [[RKObjectManager sharedManager] getObject:entity path:entity.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            fetched_entity_count++;
            
            self.loadedItems++;
            self.view.progress = self.loadedItems/self.totalItems;
            
            if (fetched_entity_count == [entities count]) {
                [cvc.collectionView reloadData];
                [cvc.collectionView sizeToFit];
                [self.view.scrollView sizeToFit];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"Failure getting entities: %@", error);
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
                // Refreshes the summary view.
                self.view.entity = self.entity;
                if (self.navigationController.viewDeckController.rightController) {
                
                    MentionsViewController *dvc = (MentionsViewController *)self.navigationController.viewDeckController.rightController;
                    [dvc.collectionView reloadData];
                }
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"Failure getting concepts: %@", error);
        }];
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(EmbeddedCollectionViewController *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Blank implementation
}

- (CollectionViewCell *)configureCell:(CollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath forEmbeddedCollectionViewController:(EmbeddedCollectionViewController *)embeddedCollectionViewController {
    return cell;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Parallax
    float y = scrollView.contentOffset.y;
    CGRect headerFrame = self.view.headerView.frame;
    
    // Scrolling down/pulling up.
    if (y >= 0) {
        headerFrame.origin.y = -y/6;
        self.view.headerView.frame = headerFrame;
        
        // Gradient and blur opacity
        //self.view.headerView.gradientView.alpha = y*1.5/CGRectGetHeight(self.view.frame);
        //self.view.headerView.blurredImageView.alpha = y*4/CGRectGetHeight(self.view.frame);
        
        // Sticky header
        // Look for the header that needs to be stuck.
        CollectionHeaderView* selectedHeader;
        for (UIView* subview in self.view.scrollView.subviews) {
            
            if ([subview isKindOfClass:[CollectionView class]]) {
                CollectionView* colview = (CollectionView*)subview;
                if (y > CGRectGetMinY(subview.frame) && self.stuckSectionHeaderView != colview.headerView) {
                    selectedHeader = colview.headerView;
                }
            }
        }
        
        // If a new header to stick was found, swap it.
        if (selectedHeader) {
            
            // Restore old header to position in UIScrollView
            if (self.stuckSectionHeaderView) {
                self.stuckSectionHeaderView.frame = self.stuckSectionHeaderViewFrame;
                [self.stuckSectionHeaderView removeFromSuperview];
                [self.stuckSectionHeaderSuperview addSubview:self.stuckSectionHeaderView];
                
                [UIView animateWithDuration:0.2 animations:^{
                    self.stuckSectionHeaderView.backgroundColor = [UIColor whiteColor];
                    self.stuckSectionHeaderView.titleLabel.textColor = [UIColor lightGrayColor];
                }];
            }
            
            // Setup new header
            // We need to keep track of:
            //  - the header view itself
            //  - the header view's superview (which could be the scroll view itself)
            //  - the original frame of the header view
            CGRect headerFrame = selectedHeader.frame;
            self.stuckSectionHeaderView = selectedHeader;
            self.stuckSectionHeaderViewFrame = headerFrame;
            self.stuckSectionHeaderSuperview = selectedHeader.superview;
            
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
            if (self.stuckSectionHeaderSuperview == self.view.scrollView) {
                threshold = CGRectGetMinY(self.stuckSectionHeaderViewFrame);
            } else {
                threshold = CGRectGetMinY(self.stuckSectionHeaderSuperview.frame);
            }
            if (y < threshold) {
                self.stuckSectionHeaderView.frame = self.stuckSectionHeaderViewFrame;
                [self.stuckSectionHeaderView removeFromSuperview];
                [self.stuckSectionHeaderSuperview addSubview:self.stuckSectionHeaderView];
                
                [UIView animateWithDuration:0.2 animations:^{
                    self.stuckSectionHeaderView.backgroundColor = [UIColor whiteColor];
                    self.stuckSectionHeaderView.titleLabel.textColor = [UIColor lightGrayColor];
                }];
                
                self.stuckSectionHeaderView = nil;
            }
        }
        
        // Scrolling up/pulling down.
    } else {
        // Stretchy header
        // NB: since we are pulling down, y is negative.
        /*
        CGFloat aspectRatio = CGRectGetWidth(self.view.headerView.cachedFrame)/CGRectGetHeight(self.view.headerView.cachedFrame);
        CGRect frame = CGRectMake(0, y,
                                  CGRectGetWidth(self.view.headerView.cachedFrame) - y*aspectRatio,
                                  CGRectGetHeight(self.view.headerView.cachedFrame) - y);
        self.view.headerView.frame = frame;
        
        CGPoint center = CGPointMake(self.view.center.x - y/aspectRatio/2, self.view.headerView.center.y - y);
        self.view.headerView.center = center;
         */
    }
}

@end
