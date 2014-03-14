//
//  StoryDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "StoryDetailViewController.h"
#import "EventDetailViewController.h"

#import "EmbeddedCollectionViewController.h"
#import "EmbeddedCollectionViewCell.h"

#import "Event.h"
#import "Concept.h"
#import "StoryTimelineViewController.h"
#import "Story+Management.h"

#import "CECardsAnimationController.h"

@interface StoryDetailViewController ()
@property (nonatomic, strong) EmbeddedCollectionViewController *eventList;
@end

@implementation StoryDetailViewController

- (instancetype)initWithStory:(Story*)story;
{
    self = [super initWithEntity:story];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.totalItems = self.entity.events.count + self.entity.concepts.count;
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(CGRectGetWidth(self.view.frame), 120)];
    self.eventList = [[EmbeddedCollectionViewController alloc] initWithCollectionViewLayout:flowLayout forEntityNamed:@"Event" withPredicate:[NSPredicate predicateWithFormat:@"SELF IN %@", self.entity.events]];
    self.eventList.managedObjectContext = self.entity.managedObjectContext;
    self.eventList.delegate = self;
    self.eventList.title = @"Events";
    
    [self.eventList.collectionView registerClass:[EmbeddedCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self addChildViewController:self.eventList];
    [self.view.scrollView addSubview:self.eventList.collectionView];
    [self.eventList didMoveToParentViewController:self];
    [self getEntities:self.entity.events forCollectionView:self.eventList];
    
    [self getConcepts:self.entity.concepts];
    
    [self.view setActionButtonTitle:@"View the full timeline"];
    [self.view.actionButton addTarget:self action:@selector(viewTimeline:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewTimeline:(id)sender
{
    StoryTimelineViewController* sevc = [[StoryTimelineViewController alloc] initWithStory:self.entity];
    sevc.transitioningDelegate = self;
    
    // Add the close button.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(
                                                                       screenRect.size.width - 48,
                                                                       [UIApplication sharedApplication].statusBarFrame.size.height,
                                                                       48, 48)];
    [closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeTimeline:) forControlEvents:UIControlEventTouchUpInside];
    
    [sevc.view addSubview:closeButton];
 
    [self presentViewController:sevc animated:YES completion:nil];
}
- (void)closeTimeline:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Setup
- (NSArray*)navigationItems
{
    NSMutableArray* navItems = [[super navigationItems] mutableCopy];
    UIBarButtonItem *paddingItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:nil
                                                                                 action:nil];
    
    UIBarButtonItem *watchingButton;
    if ([self.entity isWatched]) {
        watchingButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_watched"] style:UIBarButtonItemStylePlain target:self action:@selector(watch:)];
        watchingButton.tag = 1;
    } else {
        watchingButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_watch"] style:UIBarButtonItemStylePlain target:self action:@selector(watch:)];
        watchingButton.tag = 0;
    }
    
    // Disable the button while we update the watched status.
    watchingButton.enabled = NO;
    [self.entity checkWatched:^(Story *story) {
        watchingButton.image = [UIImage imageNamed:@"nav_watched"];
        watchingButton.tag = 1;
        watchingButton.enabled = YES;
    } notWatched:^(Story *story) {
        watchingButton.image = [UIImage imageNamed:@"nav_watch"];
        watchingButton.tag = 0;
        watchingButton.enabled = YES;
    }];
    
    [navItems insertObjects:@[ watchingButton, paddingItem ] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 2)]];
    return navItems;
}

#pragma mark - Watching
- (void)watch:(UIBarButtonItem*)sender
{
    if (sender.tag != 1) {
        sender.image = [UIImage imageNamed:@"nav_watched"];
        [sender setTag:1];
        [self.entity watch];
    } else {
        sender.image = [UIImage imageNamed:@"nav_watch"];
        [sender setTag:0];
        [self.entity unwatch];
    }
}

# pragma mark - EmbeddedCollectionViewControllerDelegate
- (CollectionViewCell*)configureCell:(EmbeddedCollectionViewCell *)cell atIndexPath:(NSIndexPath*)indexPath forEmbeddedCollectionViewController:(EmbeddedCollectionViewController *)embeddedCollectionViewController
{
    if (embeddedCollectionViewController == self.eventList) {
        Event *event = [embeddedCollectionViewController.fetchedResultsController objectAtIndexPath:indexPath];
        
        [self.eventList handleImageForEntity:(id)event forCell:cell atIndexPath:indexPath];
        
        cell.titleLabel.text = event.title;
        cell.timeLabel.text = [event.updatedAt timeAgo];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [[self.entity.events allObjects] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[[EventDetailViewController alloc] initWithEvent:event] animated:YES];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    CECardsAnimationController *transition = [[CECardsAnimationController alloc] init];
    transition.reverse = NO;
    return transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    CECardsAnimationController *transition = [[CECardsAnimationController alloc] init];
    transition.reverse = YES;
    return transition;
}

@end
