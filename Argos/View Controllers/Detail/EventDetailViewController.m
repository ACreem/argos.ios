//
//  EventDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/7/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EventDetailViewController.h"
//#import "StoryDetailViewController.h"
//#import "WebViewController.h"

#import "EmbeddedCollectionViewController.h"
#import "ArticleViewCell.h"
#import "CollectionViewCell.h"

#import "Article.h"
#import "Source.h"
#import "Event+Management.h"

#import "EventListViewController.h"
#import "EventTabBarController.h"

#import "EventDetailView.h"

@interface EventDetailViewController ()
@property (nonatomic, strong) EmbeddedCollectionViewController *articleList;
@property (nonatomic, strong) EmbeddedCollectionViewController *storyList;
@end

@implementation EventDetailViewController

- (instancetype)initWithEvent:(Event*)event;
{
    self = [super initWithEntity:event];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.view = [[EventDetailView alloc] initWithFrame:bounds forEvent:self.entity];
    self.view.delegate = self;
    
    self.totalItems = self.entity.articles.count + self.entity.concepts.count;
    
    [self getConcepts:self.entity.concepts];
    
    // Tab bar
    EventTabBarController *eventTabBarController = [[EventTabBarController alloc] initWithEvent:self.entity];
    eventTabBarController.detailDelegate = self;
    [self.view.scrollView addSubview:eventTabBarController.view];
    [self addChildViewController:eventTabBarController];
    [eventTabBarController didMoveToParentViewController:self];
    
    [self.view.scrollView sizeToFit];
}

- (NSArray*)navigationItems
{
    NSMutableArray* navItems = [[super navigationItems] mutableCopy];
    UIBarButtonItem *paddingItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:nil
                                                                                 action:nil];
    
    // TO DO: need to implement functionality for promote button
    UIBarButtonItem *promoteButton;
    promoteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_promote"] style:UIBarButtonItemStylePlain target:self action:@selector(bookmark:)];
    
    UIBarButtonItem *bookmarkButton;
    if ([self.entity isBookmarked]) {
        bookmarkButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_bookmarked"] style:UIBarButtonItemStylePlain target:self action:@selector(bookmark:)];
        bookmarkButton.tag = 1;
    } else {
        bookmarkButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_bookmark"] style:UIBarButtonItemStylePlain target:self action:@selector(bookmark:)];
        bookmarkButton.tag = 0;
    }
    bookmarkButton.enabled = NO; // disable for now, checkBookmarked will enable it when ready.
    
    [self.entity checkBookmarked:^(Event *event){
        bookmarkButton.image = [UIImage imageNamed:@"nav_bookmarked"];
        bookmarkButton.tag = 1;
        bookmarkButton.enabled = YES;
    } notBookmarked:^(Event *event) {
        bookmarkButton.image = [UIImage imageNamed:@"nav_bookmark"];
        bookmarkButton.tag = 0;
        bookmarkButton.enabled = YES;
    }];
    
    UIBarButtonItem *watchingButton;
    //if ([self.entity isWatched]) {
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
    
    [navItems insertObjects:@[ promoteButton, paddingItem, bookmarkButton, paddingItem, watchingButton, paddingItem ] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 6)]];
    return navItems;
}

#pragma mark - Bookmarking
- (void)bookmark:(UIBarButtonItem*)sender
{
    if (sender.tag != 1) {
        sender.image = [UIImage imageNamed:@"nav_bookmarked"];
        [sender setTag:1];
        [self.entity bookmark];
    } else {
        sender.image = [UIImage imageNamed:@"nav_bookmark"];
        [sender setTag:0];
        [self.entity unbookmark];
    }
}

@end
