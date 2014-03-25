//
//  MentionsViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/28/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "MentionsViewController.h"
#import "CollectionViewCell.h"

#import "Concept.h"

// For getting the ledge size.
#import "IIViewDeckController.h"

@interface MentionsViewController ()
@property (nonatomic, strong) UILabel *noteLabel;
@end

@implementation MentionsViewController

- (MentionsViewController*)initWithEntity:(BaseEntity*)entity withPredicate:(NSPredicate*)predicate
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    // Temporary, these are overridden later according to the view deck controller's ledge size.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [flowLayout setItemSize:CGSizeMake(screenRect.size.width, kLargeCellHeight)];
    [flowLayout setSectionInset:UIEdgeInsetsZero];
    
    self.managedObjectContext = entity.managedObjectContext;
    
    self = [super initWithCollectionViewLayout:flowLayout forEntityNamed:@"Concept" withPredicate:predicate];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.078 green:0.086 blue:0.114 alpha:1.0];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.bounces = NO;
    
    self.sortKey = @"updatedAt";
    
    // Setup proper layout sizing.
    // Account for view deck controller's ledge size, and also
    // set a top inset for the header bar (same size as the navigation bar +  status bar).
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat ledgeSize = self.viewDeckController.rightSize;
    CGFloat itemWidth = screenRect.size.width - ledgeSize;
    [(UICollectionViewFlowLayout*)self.collectionViewLayout setItemSize:CGSizeMake(screenRect.size.width - ledgeSize, kLargeCellHeight)];
    [(UICollectionViewFlowLayout*)self.collectionViewLayout setSectionInset:UIEdgeInsetsMake(64, ledgeSize, 0, 0)];
    
    // Setup the header.
    // The label is in a view so we can have some left padding.
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(ledgeSize, 20, itemWidth, 44)];
    headerView.backgroundColor = [UIColor actionColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, itemWidth, 44)];
    headerLabel.text = @"Mentions";
    headerLabel.font = [UIFont lightFontForSize:16];
    headerLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:headerLabel];
    [self.view addSubview:headerView];
    
    if (self.fetchedResultsController.fetchedObjects.count == 0) {
        CGRect screenRect = [UIScreen mainScreen].bounds;
        CGFloat padding = 12;
        self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding + ledgeSize, screenRect.size.height/2 - 36 - padding, screenRect.size.width - 2*padding - ledgeSize, 36)];
        self.noteLabel.text = @"No concepts were mentioned here.";
        self.noteLabel.font = [UIFont titleFontForSize:14.0];
        self.noteLabel.textAlignment = NSTextAlignmentCenter;
        self.noteLabel.backgroundColor = [UIColor actionColor];
        self.noteLabel.textColor = [UIColor whiteColor];
        [self.collectionView addSubview:self.noteLabel];
        [self.collectionView bringSubviewToFront:self.noteLabel];
    }
}

# pragma mark - UIControllerViewDelegate
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell*)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    Concept* concept = [self.fetchedResultsController objectAtIndexPath:indexPath];

    [cell configureCellForConcept:concept];
    
    return cell;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (controller.fetchedObjects.count > 0) {
        [self.noteLabel removeFromSuperview];
        self.noteLabel = nil;
    }
    [self.collectionView reloadData];
}



@end
