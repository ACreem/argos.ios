//
//  SearchResultsViewController.m
//  Argos
//
//  Created by Francis Tseng on 3/9/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "AREmbeddedCollectionViewCell.h"
#import "SearchViewController.h"

@interface SearchResultsViewController ()

@end

@implementation SearchResultsViewController

- (instancetype)initForEntityNamed:(NSString*)entityName
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [flowLayout setSectionInset:UIEdgeInsetsMake(32, 0, 0, 0)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [flowLayout setItemSize:CGSizeMake(screenRect.size.width, 120)];
    
    // Initialize the predicate so nothing is returned.
    self = [super initWithCollectionViewLayout:flowLayout forEntityNamed:entityName withPredicate:[NSPredicate predicateWithValue:NO]];
    self.managedObjectContext = [[ARObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    self.sortKey = @"updatedAt";
    
    if (self) {
        self.navigationItem.title = @""; // No title since the search bar is in the navigation bar.
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[AREmbeddedCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.backgroundColor = [UIColor primaryColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tap];
}

# pragma mark - UICollectionViewDelegate
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AREmbeddedCollectionViewCell *cell = (AREmbeddedCollectionViewCell*)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    id <AREntitySearchResult> entity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self handleImageForEntity:entity forCell:cell atIndexPath:indexPath];
    
    if ([entity respondsToSelector:@selector(title)]) {
        cell.titleLabel.text = entity.title;
    } else {
        cell.titleLabel.text = entity.name;
    }
    cell.timeLabel.text = [entity.updatedAt timeAgo];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
     [self.navigationController pushViewController:[[EventDetailViewController alloc] initWithEvent:event] animated:YES];
     */
}

- (void)searchForQuery:(NSString*)query
{
    // Clear the NSFetchedResultsController cache.
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    
    // Set the new predicate.
    self.predicate = [NSPredicate predicateWithFormat:@"searchQuery = %@", query];
    
    // Reset the fetched results controller.
    self.fetchedResultsController = nil;
    
    // Execute the query.
    NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    // Refresh the collection view.
    [self.collectionView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[(SearchViewController*)self.parentViewController searchBar] resignFirstResponder];
}
- (void)dismissKeyboard:(UITapGestureRecognizer*)sender
{
    [[(SearchViewController*)self.parentViewController searchBar] resignFirstResponder];
}

@end
