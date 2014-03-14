//
//  StoryDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "StoryDetailViewController.h"
#import "EventDetailViewController.h"

#import "AREmbeddedCollectionViewController.h"
#import "AREmbeddedCollectionViewCell.h"

#import "Event.h"
#import "Entity.h"
#import "StoryTimelineViewController.h"

#import "CECardsAnimationController.h"

@interface StoryDetailViewController () {
    Story *_story;
    AREmbeddedCollectionViewController *_eventList;
}
@property (strong, nonatomic) UIBarButtonItem *watchingButton;

@end

@implementation StoryDetailViewController

- (StoryDetailViewController*)initWithStory:(Story*)story;
{
    self = [super init];
    if (self) {
        // Load requested story
        self.viewTitle = story.title;
        _story = story;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.totalItems = _story.events.count + _story.entities.count;
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    [self setHeaderImageForEntity:_story];
    
    
    // Summary view
    CGPoint summaryOrigin = CGPointMake(bounds.origin.x, self.headerView.bounds.size.height);
    self.summaryView = [[ARSummaryView alloc] initWithOrigin:summaryOrigin text:_story.summary updatedAt:_story.updatedAt];
    self.summaryView.delegate = self;
    [self.scrollView addSubview:self.summaryView];
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(bounds.size.width, 120)];
    _eventList = [[AREmbeddedCollectionViewController alloc] initWithCollectionViewLayout:flowLayout forEntityNamed:@"Event" withPredicate:[NSPredicate predicateWithFormat:@"SELF IN %@", _story.events]];
    _eventList.managedObjectContext = _story.managedObjectContext;
    _eventList.delegate = self;
    _eventList.title = @"Events";
    
    [_eventList.collectionView registerClass:[AREmbeddedCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self addChildViewController:_eventList];
    [self.scrollView addSubview:_eventList.collectionView];
    [_eventList didMoveToParentViewController:self];
    [self fetchEvents];
    
    [self fetchEntities];
    
    float textPaddingVertical = 8.0;
    UIButton* storyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [storyButton setTitle:@"View the full timeline" forState:UIControlStateNormal];
    storyButton.titleLabel.font = [UIFont mediumFontForSize:14];
    [storyButton sizeToFit];
    storyButton.frame = CGRectMake(0, 0,
                                   storyButton.frame.size.width + 20,
                                   storyButton.frame.size.height);
    storyButton.tintColor = [UIColor actionColor];
    [[storyButton layer] setBorderWidth:1.0];
    [[storyButton layer] setBorderColor:[UIColor actionColor].CGColor];
    [[storyButton layer] setCornerRadius:4.0];
    CGRect buttonFrame = storyButton.frame;
    buttonFrame.origin.x = bounds.size.width/2 - storyButton.bounds.size.width/2;
    buttonFrame.origin.y = textPaddingVertical*2;
    
    UIView *actionsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.summaryView.summaryWebView.frame.origin.y + self.summaryView.summaryWebView.frame.size.height, bounds.size.width, buttonFrame.size.height + textPaddingVertical*2)];
    storyButton.frame = buttonFrame;
    [storyButton addTarget:self action:@selector(viewTimeline:) forControlEvents:UIControlEventTouchUpInside];
    [actionsView addSubview:storyButton];
    
    [self.summaryView addSubview:actionsView];
}

- (void)viewTimeline:(id)sender
{
    StoryTimelineViewController* sevc = [[StoryTimelineViewController alloc] initWithStory:_story];
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
- (void)fetchEntities
{
    // Fetch entities.
    __block NSUInteger fetched_entity_count = 0;
    for (Entity* entity in _story.entities) {
        [[RKObjectManager sharedManager] getObject:entity path:entity.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            fetched_entity_count++;
            
            self.loadedItems++;
            [self.progressView setProgress:self.loadedItems/self.totalItems animated:YES];
            
            if (fetched_entity_count == [_story.entities count]) {
                [self.summaryView setText:_story.summary withMentions:_story.mentions];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
}

- (void)fetchEvents
{
    for (Event* event in _story.events) {
        __block NSUInteger fetched_event_count = 0;
        [[RKObjectManager sharedManager] getObject:event path:event.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            fetched_event_count++;
            
            self.loadedItems++;
            [self.progressView setProgress:self.loadedItems/self.totalItems animated:YES];
            
            if (fetched_event_count == [_story.events count]) {
                [_eventList.collectionView reloadData];
                [_eventList.collectionView sizeToFit];
                [self.scrollView sizeToFit];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
}

- (NSArray*)navigationItems
{
    // Called in superclass (ARDetailViewController) viewDidLoad
    UIBarButtonItem *paddingItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:nil
                                                                                 action:nil];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    UIBarButtonItem *fontButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_font"] style:UIBarButtonItemStylePlain target:self action:@selector(font:)];
    
    if ([[[ARObjectManager sharedManager] currentUser].watching containsObject:_story] ) {
        self.watchingButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_watched"] style:UIBarButtonItemStylePlain target:self action:@selector(watch:)];
        self.watchingButton.tag = 1;
    } else {
        self.watchingButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_watch"] style:UIBarButtonItemStylePlain target:self action:@selector(watch:)];
        self.watchingButton.tag = 0;
    }
    self.watchingButton.enabled = NO; // disable for now, checkBookmark will enable it when ready.
    [self checkWatching];
    
    return [NSArray arrayWithObjects:shareButton, paddingItem, self.watchingButton, paddingItem, fontButton, paddingItem, nil];
}

#pragma mark - Watching
- (void)checkWatching
{
    [[[ARObjectManager sharedManager] client] getPath:[NSString stringWithFormat:@"/user/watching/%@", _story.storyId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.watchingButton.image = [UIImage imageNamed:@"nav_watched"];
        self.watchingButton.tag = 1;
        self.watchingButton.enabled = YES;
        [[[ARObjectManager sharedManager] currentUser] addWatchingObject:_story];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([operation.response statusCode] == 404) {
            self.watchingButton.image = [UIImage imageNamed:@"nav_watch"];
            self.watchingButton.tag = 0;
            self.watchingButton.enabled = YES;
            [[[ARObjectManager sharedManager] currentUser] removeWatchingObject:_story];
        } else {
            NSLog(@"some non-404 error");
        }
    }];
}

- (void)watchStory:(Story*)story
{
    [[[ARObjectManager sharedManager] client] postPath:@"/user/watching" parameters:@{@"story_id": story.storyId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        [[[ARObjectManager sharedManager] currentUser] addWatchingObject:story];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];
}

- (void)unwatchStory:(Story*)story
{
    [[[ARObjectManager sharedManager] client] deletePath:[NSString stringWithFormat:@"/user/watching/%@", story.storyId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        [[[ARObjectManager sharedManager] currentUser] removeWatchingObject:story];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];
}

- (void)watch:(id)sender
{
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    if (button.tag != 1) {
        button.image = [UIImage imageNamed:@"nav_watched"];
        [button setTag:1];
        [self watchStory:_story];
    } else {
        button.image = [UIImage imageNamed:@"nav_watch"];
        [button setTag:0];
        [self unwatchStory:_story];
    }
}

# pragma mark - AREmbeddedCollectionViewControllerDelegate
- (ARCollectionViewCell*)configureCell:(AREmbeddedCollectionViewCell *)cell atIndexPath:(NSIndexPath*)indexPath forEmbeddedCollectionViewController:(AREmbeddedCollectionViewController *)embeddedCollectionViewController
{
    if (embeddedCollectionViewController == _eventList) {
        Event *event = [embeddedCollectionViewController.fetchedResultsController objectAtIndexPath:indexPath];
        
        [_eventList handleImageForEntity:(id)event forCell:cell atIndexPath:indexPath];
        
        cell.titleLabel.text = event.title;
        cell.timeLabel.text = [event.updatedAt timeAgo];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [[_story.events allObjects] objectAtIndex:indexPath.row];
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
