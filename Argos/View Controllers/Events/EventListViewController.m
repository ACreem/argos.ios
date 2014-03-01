//
//  EventListViewController.m
//  Argos
//
//  Created by Francis Tseng on 1/27/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EventListViewController.h"
#import "EventDetailViewController.h"
#import "ARFullCollectionViewCell.h"
#import "Event.h"

@interface EventListViewController ()
@property (strong, nonatomic) NSString *stream;
@end

@implementation EventListViewController

- (id)initWithTitle:(NSString*)title stream:(NSString*)stream
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [flowLayout setSectionInset:UIEdgeInsetsZero];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self = [super initWithCollectionViewLayout:flowLayout forEntityNamed:@"Event"];
    
    if (self) {
        self.navigationItem.title = title;
        _stream = stream;
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
    screenRect.size.height -= ([UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height);
    [(UICollectionViewFlowLayout*)self.collectionViewLayout setItemSize:screenRect.size];
    
    [self.collectionView registerClass:[ARFullCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.backgroundColor = [UIColor primaryColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.alwaysBounceVertical = YES; // necessary for pull-to-refresh
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    self.refreshControl.tintColor = [UIColor grayColor];
    
    [self loadData];
    [self.refreshControl beginRefreshing];
}

- (void)loadData
{
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/events" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self.refreshControl endRefreshing];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self.refreshControl endRefreshing];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An Error Has Occurred" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}

# pragma mark - UIControllerViewDelegate
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARFullCollectionViewCell *cell = (ARFullCollectionViewCell*)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self handleImageForEntity:(id)event forCell:cell atIndexPath:indexPath];
    
    cell.titleLabel.text = event.title;
    cell.textLabel.text = event.summary;
    cell.timeLabel.text = [NSDate dateDiff:event.updatedAt];
    
    return cell;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ARTableViewCell *cell = (ARTableViewCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    UIImageView *favoriteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favorite"]];
    [cell setSwipeGestureWithView:favoriteView color:[UIColor secondaryColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"favorited");
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favorited_icon"]];
        iconView.frame = CGRectMake(0,0,16,16);
        ARTableViewCell* arcell = (ARTableViewCell*)cell;
        [arcell.iconsView addSubview:iconView];
    }];
    
    UIImageView *watchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"watch"]];
    [cell setSwipeGestureWithView:watchView color:[UIColor secondaryColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"watched");
    }];
    
    
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self handleImageForEntity:(id)event forCell:cell atIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = event.title;
    cell.timeLabel.text = [NSDate dateDiff:event.updatedAt];
    
    return cell;
}
 */

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:[[EventDetailViewController alloc] initWithEvent:event] animated:YES];
}

@end
