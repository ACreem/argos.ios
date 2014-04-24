//
//  EventListViewController.m
//  Argos
//
//  Created by Francis Tseng on 1/27/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EventListViewController.h"
#import "EventDetailViewController.h"
#import "EventViewCell.h"
#import "Event.h"

@interface EventListViewController ()
@end

@implementation EventListViewController

- (id)initWithTitle:(NSString*)title
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [flowLayout setSectionInset:UIEdgeInsetsZero];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self = [super initWithCollectionViewLayout:flowLayout forEntityNamed:@"Event"];
    
    if (self) {
        self.navigationItem.title = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the item size here,
    // because only now do we have access to self.navigationController's bar height;
    // This is not in the initialize because when this view controller is initialized,
    // it is not pushed onto a navigation controller stack yet,
    // so self.navigationController is null.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [(UICollectionViewFlowLayout*)self.collectionViewLayout setItemSize:CGSizeMake(screenRect.size.width - 20, 100)];
    
    [self.collectionView registerClass:[EventViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.918 green:0.918 blue:0.918 alpha:1.0];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = NO;
    self.collectionView.alwaysBounceVertical = YES; // necessary for pull-to-refresh
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    self.refreshControl.tintColor = [UIColor secondaryColor];
    
    [self loadData];
    [self.refreshControl beginRefreshing];
}

- (void)loadData
{
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/events" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self.refreshControl endRefreshing];
        [self.collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self.refreshControl endRefreshing];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An Error Has Occurred" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}

# pragma mark - UIControllerViewDelegate
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell*)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureCellForEvent:event];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:[[EventDetailViewController alloc] initWithEvent:event] animated:YES];
}

@end
