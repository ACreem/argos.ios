//
//  MentionsViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/28/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "MentionsViewController.h"
#import "SnippetCollectionViewCell.h"

#import "Concept.h"

// For getting the ledge size.
#import "IIViewDeckController.h"

@interface MentionsViewController ()

@end

@implementation MentionsViewController

- (MentionsViewController*)initWithEntity:(BaseEntity*)concept withPredicate:(NSPredicate*)predicate
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    // Temporary, these are overridden later according to the view deck controller's ledge size.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [flowLayout setItemSize:CGSizeMake(screenRect.size.width, 220)];
    [flowLayout setSectionInset:UIEdgeInsetsZero];
    
    self.managedObjectContext = concept.managedObjectContext;
    
    self = [super initWithCollectionViewLayout:flowLayout forEntityNamed:@"Concept" withPredicate:predicate];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[SnippetCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.bounces = NO;
    
    self.sortKey = @"updatedAt";
    
    // Setup proper layout sizing.
    // Account for view deck controller's ledge size, and also
    // set a top inset for the header bar (same size as the navigation bar +  status bar).
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float ledgeSize = self.viewDeckController.rightSize;
    float itemWidth = screenRect.size.width - ledgeSize;
    [(UICollectionViewFlowLayout*)self.collectionViewLayout setItemSize:CGSizeMake(screenRect.size.width - ledgeSize, 220)];
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
}

# pragma mark - UIControllerViewDelegate
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SnippetCollectionViewCell *cell = (SnippetCollectionViewCell*)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    Concept* concept = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self handleImageForEntity:(id)concept forCell:cell atIndexPath:indexPath];
    
    cell.titleLabel.text = concept.title;
    NSString *summaryText = @"We have no summary for this concept yet. Please help by submitting one!";
    if (concept.summary) {
        summaryText = concept.summary;
    }
    cell.textLabel.text = summaryText;
    
    return cell;
}



@end
