//
//  EventDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/7/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EventDetailViewController.h"
#import "StoryDetailViewController.h"
#import "WebViewController.h"

#import "EmbeddedCollectionViewController.h"
#import "ArticleCollectionViewCell.h"
#import "CollectionViewCell.h"

#import "Article.h"
#import "Source.h"
#import "Event+Management.h"

#import "EventListViewController.h"

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
    self.view = [[EventDetailView alloc] initWithFrame:bounds];
    self.view.delegate = self;
    self.view.entity = self.entity;
    
    self.totalItems = self.entity.stories.count + self.entity.articles.count + self.entity.concepts.count;
    
    // Show story button if this event belongs to only one story.
    if ([self.entity.stories count] == 1) {
        
    } else {
        // Otherwise show a list of stories.
        
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(CGRectGetWidth(self.view.frame), 80)];
        self.storyList = [[EmbeddedCollectionViewController alloc] initWithCollectionViewLayout:flowLayout forEntityNamed:@"Story" withPredicate:[NSPredicate predicateWithFormat:@"SELF IN %@", self.entity.stories]];
        self.storyList.managedObjectContext = self.entity.managedObjectContext;
        self.storyList.delegate = self;
        self.storyList.title = @"Stories";
        [self.storyList.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        [self addChildViewController:self.storyList];
        [self.view.scrollView addSubview:self.storyList.view];
        [self.storyList didMoveToParentViewController:self];
    }
    [self getEntities:self.entity.stories forCollectionView:self.storyList];
    
    [self getConcepts:self.entity.concepts];
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(CGRectGetWidth(self.view.frame), 80)];
    self.articleList = [[EmbeddedCollectionViewController alloc] initWithCollectionViewLayout:flowLayout forEntityNamed:@"Article" withPredicate:[NSPredicate predicateWithFormat:@"SELF IN %@", self.entity.articles]];
    self.articleList.managedObjectContext = self.entity.managedObjectContext;
    self.articleList.delegate = self;
    self.articleList.title = @"In Greater Depth";
    
    [self.articleList.collectionView registerClass:[ArticleCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self addChildViewController:self.articleList];
    [self.view.scrollView addSubview:self.articleList.collectionView];
    [self.articleList didMoveToParentViewController:self];
    [self.articleList.collectionView sizeToFit];
    
    [self getEntities:self.entity.articles forCollectionView:self.articleList];
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

# pragma mark - Actions
- (void)viewStory:(id)sender
{
    // Called if there is one story.
    Story* story = [[self.entity.stories allObjects] firstObject];
    [self.navigationController pushViewController:[[StoryDetailViewController alloc] initWithStory:story] animated:YES];
}

# pragma mark - EmbeddedCollectionViewControllerDelegate
- (ArticleCollectionViewCell*)configureCell:(ArticleCollectionViewCell *)cell atIndexPath:(NSIndexPath*)indexPath forEmbeddedCollectionViewController:(EmbeddedCollectionViewController *)embeddedCollectionViewController
{
    if (embeddedCollectionViewController == self.articleList) {
        Article *article = [embeddedCollectionViewController.fetchedResultsController objectAtIndexPath:indexPath];
        
        cell.titleLabel.text = article.title;
        cell.metaLabel.text = article.source.name;
        cell.timeLabel.text = [article.createdAt timeAgo];
        
        if (!article.imageUrl) {
            cell.imageView.hidden = YES;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.articleList.collectionView) {
        Article *article = [[self.entity.articles allObjects] objectAtIndex:indexPath.row];
        WebViewController *webView = [[WebViewController alloc] initWithURL:article.extUrl];
        [self.navigationController pushViewController:webView animated:YES];
    }
}


@end
