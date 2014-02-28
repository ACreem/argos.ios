//
//  EntityListViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/28/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EntityListViewController.h"
#import "ARClipCollectionViewCell.h"

#import "Entity.h"

// For getting the ledge size.
#import "IIViewDeckController.h"

@interface EntityListViewController ()

@end

@implementation EntityListViewController

- (EntityListViewController*)initWithEntity:(id<Entity>)entity;
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    // Temporary, these are overridden later according to the view deck controller's ledge size.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [flowLayout setItemSize:CGSizeMake(screenRect.size.width, 220)];
    [flowLayout setSectionInset:UIEdgeInsetsZero];
    
    self.managedObjectContext = entity.managedObjectContext;
    
    // For now just get all entities.
    self = [super initWithCollectionViewLayout:flowLayout forEntityNamed:@"Entity"];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[ARClipCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.bounces = NO;
    
    // Currently, Entities do not have a "createdAt" value.
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
    headerLabel.font = [UIFont fontWithName:@"Graphik-Light" size:16.0];
    headerLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:headerLabel];
    [self.view addSubview:headerView];
}

# pragma mark - UIControllerViewDelegate
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARClipCollectionViewCell *cell = (ARClipCollectionViewCell*)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    Entity* entity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self handleImageForEntity:(id)entity forCell:cell atIndexPath:indexPath];
    
    cell.titleLabel.text = entity.name;
    //cell.textLabel.text = entity.summary;
    
    return cell;
}



@end
