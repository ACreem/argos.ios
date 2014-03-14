//
//  StoryTimelineViewController.m
//  Argos
//
//  Created by Francis Tseng on 3/1/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "StoryTimelineViewController.h"
#import "ARCardCollectionViewCell.h"
#import "Event.h"

#import "EventDetailViewController.h"

@interface StoryTimelineViewController ()
@property (strong, nonatomic) Story* story;
@property (assign, nonatomic) float padding;
@end

@implementation StoryTimelineViewController

- (StoryTimelineViewController*)initWithStory:(Story*)story;
{
    _padding = 24;
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:_padding*2];
    [flowLayout setSectionInset:UIEdgeInsetsMake(_padding + [UIApplication sharedApplication].statusBarFrame.size.height, _padding, _padding, _padding)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //self = [super initWithCollectionViewLayout:flowLayout forEntityNamed:@"Event" withPredicate:[NSPredicate predicateWithFormat:@"SELF IN %@", story.events]];
    // temporary: all events
    self = [super initWithCollectionViewLayout:flowLayout forEntityNamed:@"Event"];
    if (self) {
        _story = story;
        self.managedObjectContext = _story.managedObjectContext;
        self.navigationItem.title = @"Timeline";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Setup item size.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenRect.size.height -= ([UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height + _padding*2);
    screenRect.size.height /= 1.5;
    screenRect.size.width -= _padding*2;
    [(UICollectionViewFlowLayout*)self.collectionViewLayout setItemSize:screenRect.size];
    
    [self.collectionView registerClass:[ARCardCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.backgroundColor = [UIColor secondaryColor];
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    //self.collectionView.pagingEnabled = YES;
    self.collectionView.alwaysBounceVertical = NO;
    
    [self loadData];
}

// Temporary: get all events...
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
    ARCardCollectionViewCell *cell = (ARCardCollectionViewCell*)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self handleImageForEntity:(id)event forCell:cell atIndexPath:indexPath];
    
    cell.titleLabel.text = event.title;
    cell.textLabel.text = event.summary;
    cell.timeLabel.text = [event.updatedAt timeAgo];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:[[EventDetailViewController alloc] initWithEvent:event] animated:YES];
}

@end
