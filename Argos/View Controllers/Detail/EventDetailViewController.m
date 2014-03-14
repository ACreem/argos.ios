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

#import "AREmbeddedCollectionViewController.h"
#import "ARArticleCollectionViewCell.h"
#import "AREmbeddedCollectionViewCell.h"

#import "Article.h"
#import "Source.h"
#import "Event+Management.h"

#import "EventListViewController.h"

@interface EventDetailViewController ()
@property (nonatomic, strong) AREmbeddedCollectionViewController *articleList;
@property (nonatomic, strong) AREmbeddedCollectionViewController *storyList;
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
    
    self.totalItems = self.entity.stories.count + self.entity.articles.count + self.entity.concepts.count;
    
    // Show story button if this event belongs to only one story.
    if ([self.entity.stories count] == 1) {
        [self.view setActionButtonTitle:@"View the full story"];
        [self.view.actionButton addTarget:self action:@selector(viewStory:) forControlEvents:UIControlEventTouchUpInside];
        
        // Otherwise show a list of stories.
    } else {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(CGRectGetWidth(self.view.frame), 80)];
        _storyList = [[AREmbeddedCollectionViewController alloc] initWithCollectionViewLayout:flowLayout forEntityNamed:@"Story" withPredicate:[NSPredicate predicateWithFormat:@"SELF IN %@", self.entity.stories]];
        _storyList.managedObjectContext = self.entity.managedObjectContext;
        _storyList.delegate = self;
        _storyList.title = @"Stories";
        [_storyList.collectionView registerClass:[AREmbeddedCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        [self addChildViewController:_storyList];
        [self.view.scrollView addSubview:_storyList.view];
        [_storyList didMoveToParentViewController:self];
    }
    [self getEntities:self.entity.stories forCollectionView:_storyList];
    
    [self getConcepts:self.entity.concepts];
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(CGRectGetWidth(self.view.frame), 80)];
    _articleList = [[AREmbeddedCollectionViewController alloc] initWithCollectionViewLayout:flowLayout forEntityNamed:@"Article" withPredicate:[NSPredicate predicateWithFormat:@"SELF IN %@", self.entity.articles]];
    _articleList.managedObjectContext = self.entity.managedObjectContext;
    _articleList.delegate = self;
    _articleList.title = @"In Greater Depth";
    
    [_articleList.collectionView registerClass:[ARArticleCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self addChildViewController:_articleList];
    [self.view.scrollView addSubview:_articleList.collectionView];
    [_articleList didMoveToParentViewController:self];
    
    [self getEntities:self.entity.articles forCollectionView:_articleList];
}

- (NSArray*)navigationItems
{
    NSMutableArray* navItems = [[super navigationItems] mutableCopy];
    UIBarButtonItem *paddingItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:nil
                                                                                 action:nil];
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
    
    [navItems insertObjects:@[ bookmarkButton, paddingItem ] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 2)]];
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

# pragma mark - AREmbeddedCollectionViewControllerDelegate
- (ARCollectionViewCell*)configureCell:(ARArticleCollectionViewCell *)cell atIndexPath:(NSIndexPath*)indexPath forEmbeddedCollectionViewController:(AREmbeddedCollectionViewController *)embeddedCollectionViewController
{
    if (embeddedCollectionViewController == _articleList) {
        Article *article = [embeddedCollectionViewController.fetchedResultsController objectAtIndexPath:indexPath];
        
        cell.titleLabel.text = article.title;
        cell.metaLabel.text = article.source.name;
        cell.timeLabel.text = [article.createdAt timeAgo];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _articleList.collectionView) {
        Article *article = [[self.entity.articles allObjects] objectAtIndex:indexPath.row];
        WebViewController *webView = [[WebViewController alloc] initWithURL:article.extUrl];
        [self.navigationController pushViewController:webView animated:YES];
    }
}


@end
