//
//  ARSearchCollectionViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/25/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARSearchCollectionViewController.h"
#import "ARLargeCollectionViewCell.h"

#import "Event.h"

@implementation ARSearchCollectionViewController

- (id)init
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [flowLayout setSectionInset:UIEdgeInsetsMake(44, 0, 0, 0)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [flowLayout setItemSize:CGSizeMake(screenRect.size.width, 120)];
    
    
    // Just loading all events for now.
    self = [super initWithCollectionViewLayout:flowLayout forEntityNamed:@"Event"];
    self.managedObjectContext = [[ARObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    if (self) {
        self.navigationItem.title = @"Search";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = NO;
    
    [self.collectionView registerClass:[ARLargeCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.backgroundColor = [UIColor primaryColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = NO;
    
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.collectionView.frame.size.width, 44)];
    searchBar.barTintColor = [UIColor primaryColor];
    searchBar.translucent = NO;
    searchBar.delegate = self;
    searchBar.tintColor = [UIColor secondaryColor];
    [self.view addSubview:searchBar];
}

# pragma mark - UIControllerViewDelegate
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARLargeCollectionViewCell *cell = (ARLargeCollectionViewCell*)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self handleImageForEntity:(id)event forCell:cell atIndexPath:indexPath];
    
    cell.titleLabel.text = event.title;
    cell.timeLabel.text = [NSDate dateDiff:event.updatedAt];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:[[EventDetailViewController alloc] initWithEvent:event] animated:YES];
     */
}

# pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searching...");
    [searchBar resignFirstResponder];
}

@end
