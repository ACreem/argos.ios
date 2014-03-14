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
#import "ARGalleryViewController.h"

#import "Article.h"
#import "Story.h"
#import "Entity.h"
#import "Source.h"

#import "EventListViewController.h"

#import "IIViewDeckController.h"
#import "MentionsViewController.h"

#import "AppDelegate.h"
#import "CurrentUser+Management.h"

@interface EventDetailViewController ()
@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) AREmbeddedCollectionViewController *articleList;
@property (nonatomic, strong) AREmbeddedCollectionViewController *storyList;
@property (nonatomic, strong) UIBarButtonItem *bookmarkButton;
@property (nonatomic, assign) CGRect bounds;
@end

@implementation EventDetailViewController

- (EventDetailViewController*)initWithEvent:(Event*)event;
{
    self = [super init];
    if (self) {
        // Load requested event
        self.viewTitle = event.title;
        _event = event;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.totalItems = _event.stories.count + _event.articles.count + _event.entities.count;
    
    _bounds = [[UIScreen mainScreen] bounds];
    
    [self setHeaderImageForEntity:(id<AREntity>)_event];

    // Summary view
    CGPoint summaryOrigin = CGPointMake(0, self.headerView.bounds.size.height);
    self.summaryView = [[ARSummaryView alloc] initWithOrigin:summaryOrigin text:_event.summary updatedAt:_event.updatedAt];
    self.summaryView.delegate = self;
    [self setupStories];
    [self.scrollView addSubview:self.summaryView];
    
    
    // Setup the image gallery.
    ARGalleryViewController *galleryViewController = [[ARGalleryViewController alloc] init];
    CGSize gallerySize = CGSizeMake(_bounds.size.width, 220);
    [self addChildViewController:galleryViewController];
    [self.scrollView addSubview:galleryViewController.collectionView];
    [galleryViewController didMoveToParentViewController:self];
    galleryViewController.collectionView.frame = CGRectMake(0, 0, gallerySize.width, gallerySize.height);
    [(UICollectionViewFlowLayout*)galleryViewController.collectionViewLayout setItemSize:gallerySize];
    
    [self fetchEntities];
    [self setupArticles];
    
    [self.scrollView sizeToFit];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Setup the right controller (the mention pane) for the view deck.
    // Doesn't feel quite right for this view controller to reach that far up its hierarchy, but...
    self.navigationController.viewDeckController.rightController = [[MentionsViewController alloc] initWithEntity:(id<AREntity>)_event withPredicate:[NSPredicate predicateWithFormat:@"SELF in %@", _event.entities]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Remove the mention pane.
    // For whatever reason, I can't remove it the same way I added it.
    //self.navigationController.viewDeckController.rightController = nil;
    
    // It has to be removed this way, which is messy:
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.deckController.rightController = nil;
    
    [super viewDidDisappear:animated];
}

#pragma mark - Setup
- (void)setupStories
{
    float textPaddingVertical = 8.0;
    if ([_event.stories count] == 1) {
        // Story button
        // Show only if this event belongs to only one story.
        UIButton* storyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [storyButton setTitle:@"View the full story" forState:UIControlStateNormal];
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
        buttonFrame.origin.x = _bounds.size.width/2 - storyButton.bounds.size.width/2;
        buttonFrame.origin.y = textPaddingVertical*2;
        
        UIView *actionsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.summaryView.summaryWebView.frame.origin.y + self.summaryView.summaryWebView.frame.size.height, _bounds.size.width, buttonFrame.size.height + textPaddingVertical*2)];
        storyButton.frame = buttonFrame;
        [storyButton addTarget:self action:@selector(viewStory:) forControlEvents:UIControlEventTouchUpInside];
        [actionsView addSubview:storyButton];
        
        [self.summaryView addSubview:actionsView];
        
        // Otherwise show a list of stories.
    } else {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(_bounds.size.width, 80)];
        _storyList = [[AREmbeddedCollectionViewController alloc] initWithCollectionViewLayout:flowLayout forEntityNamed:@"Story" withPredicate:[NSPredicate predicateWithFormat:@"SELF IN %@", _event.stories]];
        _storyList.managedObjectContext = _event.managedObjectContext;
        _storyList.delegate = self;
        _storyList.title = @"Stories";
        
        [_storyList.collectionView registerClass:[AREmbeddedCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        
        [self addChildViewController:_storyList];
        [self.scrollView addSubview:_storyList.view];
        [_storyList didMoveToParentViewController:self];
    }
    [self fetchStories];
    [self.summaryView sizeToFit];
}



- (void)setupArticles
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(_bounds.size.width, 80)];
    _articleList = [[AREmbeddedCollectionViewController alloc] initWithCollectionViewLayout:flowLayout forEntityNamed:@"Article" withPredicate:[NSPredicate predicateWithFormat:@"SELF IN %@", _event.articles]];
    _articleList.managedObjectContext = _event.managedObjectContext;
    _articleList.delegate = self;
    _articleList.title = @"In Greater Depth";
    
    [_articleList.collectionView registerClass:[ARArticleCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self addChildViewController:_articleList];
    [self.scrollView addSubview:_articleList.collectionView];
    [_articleList didMoveToParentViewController:self];
    
    [self fetchArticles];
}

- (NSArray*)navigationItems
{
    // Called in superclass (ARDetailViewController) viewDidLoad
    UIBarButtonItem *paddingItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:nil
                                                                                 action:nil];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    UIBarButtonItem *fontButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_font"] style:UIBarButtonItemStylePlain target:self action:@selector(font:)];
    
    if ([[CurrentUser currentUser].bookmarked containsObject:_event] ) {
        self.bookmarkButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_bookmarked"] style:UIBarButtonItemStylePlain target:self action:@selector(bookmark:)];
        self.bookmarkButton.tag = 1;
    } else {
        self.bookmarkButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_bookmark"] style:UIBarButtonItemStylePlain target:self action:@selector(bookmark:)];
        self.bookmarkButton.tag = 0;
    }
    self.bookmarkButton.enabled = NO; // disable for now, checkBookmarked will enable it when ready.
    [self checkBookmarked];

    return [NSArray arrayWithObjects:shareButton, paddingItem, self.bookmarkButton, paddingItem, fontButton, paddingItem, nil];
}


# pragma mark - Fetching Data
- (void)fetchStories
{
    // Fetch stories.
    __block NSUInteger fetched_story_count = 0;
    for (Story* story in _event.stories) {
        [[RKObjectManager sharedManager] getObject:story path:story.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            fetched_story_count++;
            
            self.loadedItems++;
            [self.progressView setProgress:self.loadedItems/self.totalItems animated:YES];
            
            if (fetched_story_count == [_event.stories count] && _storyList) {
                [_storyList.collectionView reloadData];
                [_storyList.collectionView sizeToFit];
                [self.scrollView sizeToFit];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
}

- (void)fetchArticles
{
    // Fetch articles.
    // Need to keep track of how many articles have been fetched.
    // Note this is not the best way since it is possible that the number
    // of articles (or stories or entities) changes while these requests are made.
    __block NSUInteger fetched_article_count = 0;
    for (Article* article in _event.articles) {
        [[RKObjectManager sharedManager] getObject:article path:article.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            fetched_article_count++;
            
            self.loadedItems++;
            [self.progressView setProgress:self.loadedItems/self.totalItems animated:YES];
            
            if (fetched_article_count == [_event.articles count]) {
                [_articleList.collectionView reloadData];
                [_articleList.collectionView sizeToFit];
                [self.scrollView sizeToFit];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
}

- (void)fetchEntities
{
    // Fetch entities.
    __block NSUInteger fetched_entity_count = 0;
    for (Entity* entity in _event.entities) {
        [[RKObjectManager sharedManager] getObject:entity path:entity.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            fetched_entity_count++;
            
            self.loadedItems++;
            [self.progressView setProgress:self.loadedItems/self.totalItems animated:YES];
            
            if (fetched_entity_count == [_event.entities count]) {
                [self.summaryView setText:_event.summary withMentions:_event.mentions];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
}

#pragma mark - Bookmarking
- (void)checkBookmarked
{
    [[[ARObjectManager sharedManager] client] getPath:[NSString stringWithFormat:@"/user/bookmarked/%@", _event.eventId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.bookmarkButton.image = [UIImage imageNamed:@"nav_bookmarked"];
        self.bookmarkButton.tag = 1;
        self.bookmarkButton.enabled = YES;
        [[CurrentUser currentUser] addBookmarkedObject:_event];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([operation.response statusCode] == 404) {
            self.bookmarkButton.image = [UIImage imageNamed:@"nav_bookmark"];
            self.bookmarkButton.tag = 0;
            self.bookmarkButton.enabled = YES;
            [[CurrentUser currentUser] removeBookmarkedObject:_event];
        } else {
            NSLog(@"some non-404 error");
        }
    }];
}

- (void)bookmarkEvent:(Event*)event
{
    [[[ARObjectManager sharedManager] client] postPath:@"/user/bookmarked" parameters:@{@"event_id": event.eventId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        [[CurrentUser currentUser] addBookmarkedObject:event];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];
}

- (void)unbookmarkEvent:(Event*)event
{
    [[[ARObjectManager sharedManager] client] deletePath:[NSString stringWithFormat:@"/user/bookmarked/%@", _event.eventId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        [[CurrentUser currentUser] removeBookmarkedObject:event];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];
}

- (void)bookmark:(id)sender
{
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    if (button.tag != 1) {
        button.image = [UIImage imageNamed:@"nav_bookmarked"];
        [button setTag:1];
        [self bookmarkEvent:_event];
    } else {
        button.image = [UIImage imageNamed:@"nav_bookmark"];
        [button setTag:0];
        [self unbookmarkEvent:_event];
    }
}


# pragma mark - Actions
- (void)viewStory:(id)sender
{
    // Called if there is one story.
    Story* story = [[_event.stories allObjects] firstObject];
    [self.navigationController pushViewController:[[StoryDetailViewController alloc] initWithStory:story] animated:YES];
}

# pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [_articleList loadImagesForOnscreenRows];
        [_storyList loadImagesForOnscreenRows];
    }
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
        Article *article = [[_event.articles allObjects] objectAtIndex:indexPath.row];
        WebViewController *webView = [[WebViewController alloc] initWithURL:article.extUrl];
        [self.navigationController pushViewController:webView animated:YES];
    }
}


@end
