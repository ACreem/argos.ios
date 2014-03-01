//
//  EventDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/7/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EventDetailViewController.h"
#import "StoryDetailViewController.h"
#import "ArticleWebViewController.h"

#import "AREmbeddedCollectionViewController.h"
#import "ARSimpleCollectionViewCell.h"
#import "ARLargeCollectionViewCell.h"

#import "Article.h"
#import "Story.h"
#import "Entity.h"
#import "Source.h"

#import "EventListViewController.h"

#import "IIViewDeckController.h"
#import "EntityListViewController.h"

#import "AppDelegate.h"

@interface EventDetailViewController () {
    Event *_event;
    CGRect _bounds;
    AREmbeddedCollectionViewController *_articleList;
    AREmbeddedCollectionViewController *_storyList;
}

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
    
    [self setHeaderImageForEntity:(id<Entity>)_event];

    // Summary view
    CGPoint summaryOrigin = CGPointMake(0, self.headerView.bounds.size.height);
    self.summaryView = [[ARSummaryView alloc] initWithOrigin:summaryOrigin text:_event.summary updatedAt:_event.updatedAt];
    self.summaryView.delegate = self;
    [self setupStories];
    [self.scrollView addSubview:self.summaryView];
    
    [self fetchEntities];
    [self setupArticles];
    
    [self.scrollView sizeToFit];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Setup the right controller (the mention pane) for the view deck.
    // Doesn't feel quite right for this view controller to reach that far up its hierarchy, but...
    self.navigationController.viewDeckController.rightController = [[EntityListViewController alloc] initWithEntity:_event];
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
        
        [_storyList.collectionView registerClass:[ARLargeCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        
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
    
    [_articleList.collectionView registerClass:[ARSimpleCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self addChildViewController:_articleList];
    [self.scrollView addSubview:_articleList.collectionView];
    [_articleList didMoveToParentViewController:self];
    
    [self fetchArticles];
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
                [self.summaryView setText:_event.summary withEntities:_event.entities];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
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
- (ARCollectionViewCell*)configureCell:(ARSimpleCollectionViewCell *)cell atIndexPath:(NSIndexPath*)indexPath forEmbeddedCollectionViewController:(AREmbeddedCollectionViewController *)embeddedCollectionViewController
{
    if (embeddedCollectionViewController == _articleList) {
        Article *article = [embeddedCollectionViewController.fetchedResultsController objectAtIndexPath:indexPath];
        
        cell.titleLabel.text = article.title;
        cell.metaLabel.text = article.source.name;
        cell.timeLabel.text = [NSDate dateDiff:article.createdAt];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _articleList.collectionView) {
        Article *article = [[_event.articles allObjects] objectAtIndex:indexPath.row];
        ArticleWebViewController *webView = [[ArticleWebViewController alloc] initWithURL:article.extUrl];
        [self.navigationController pushViewController:webView animated:YES];
    }
}


@end
