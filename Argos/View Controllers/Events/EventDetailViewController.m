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
#import "AREmbeddedTableView.h"
#import "ARTableViewCell.h"
#import "ARTextButton.h"
#import "Article.h"
#import "Story.h"
#import "Entity.h"
#import "Source.h"

@interface EventDetailViewController () {
    Event *_event;
    CGRect _bounds;
    AREmbeddedTableView *_articleList;
    AREmbeddedTableView *_storyList;
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
    
    // Set the header image,
    // downloading if necessary.
    if (_event.image) {
        [self setHeaderImage:_event.image];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSURL* imageUrl = [NSURL URLWithString:_event.imageUrl];
            NSError* error = nil;
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl options:NSDataReadingUncached error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage* image = [UIImage imageWithData:imageData];
                _event.image = image;
                [self setHeaderImage:_event.image];
            });
        });
    }
    
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


#pragma mark - Setup
- (void)setupStories
{
    float textPaddingVertical = 8.0;
    if ([_event.stories count] == 1) {
        // Story button
        // Show only if this event belongs to only one story.
        ARTextButton *storyButton = [ARTextButton buttonWithTitle:@"View the full story"];
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
        _storyList = [[AREmbeddedTableView alloc] initWithFrame:CGRectMake(0, self.summaryView.frame.origin.y + self.summaryView.frame.size.height, _bounds.size.width, 200.0) title:@"Stories"];
        _storyList.delegate = self;
        _storyList.dataSource = self;
        
        [_storyList reloadData];
        [self.scrollView addSubview:_storyList];
        [_storyList sizeToFit];
    }
    [self fetchStories];
    [self.summaryView sizeToFit];
}

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
                [_storyList reloadData];
                [_storyList sizeToFit];
                [self.scrollView sizeToFit];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
}

- (void)setupArticles
{
    CGPoint articleListOrigin;
    if (_storyList) {
        articleListOrigin = CGPointMake(0, _storyList.frame.origin.y + _storyList.frame.size.height);
    } else {
        articleListOrigin = CGPointMake(0, self.summaryView.frame.origin.y + self.summaryView.frame.size.height);
    }
    
    _articleList = [[AREmbeddedTableView alloc] initWithFrame:CGRectMake(0, articleListOrigin.y, _bounds.size.width, 200.0) title:@"Articles"];
    _articleList.delegate = self;
    _articleList.dataSource = self;
    
    [_articleList reloadData];
    [self.scrollView addSubview:_articleList];
    [_articleList sizeToFit];
    
    [self fetchArticles];
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
                [_articleList reloadData];
                [_articleList sizeToFit];
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


#pragma mark - Actions
- (void)viewStory:(id)sender
{
    // Called if there is one story.
    Story* story = [[_event.stories allObjects] firstObject];
    [self.navigationController pushViewController:[[StoryDetailViewController alloc] initWithStory:story] animated:YES];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(AREmbeddedTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create web view for the Article.
    if (tableView == _articleList) {
        Article *article = [[_event.articles allObjects] objectAtIndex:indexPath.row];
        ArticleWebViewController *webView = [[ArticleWebViewController alloc] initWithURL:article.extUrl];
        [self.navigationController pushViewController:webView animated:YES];
    } else {
        
    }
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(AREmbeddedTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ARTableViewCell *cell = (ARTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString* title;
    NSDate* date;
    NSString* meta = @"";
    if (tableView == _articleList) {
        Article *article = [[_event.articles allObjects] objectAtIndex:indexPath.row];
        title = article.title;
        date = article.createdAt;
        meta = article.source.name;
    } else {
        Story *story = [[_event.stories allObjects] objectAtIndex:indexPath.row];
        title = story.title;
        date = story.updatedAt;
    }
    
    cell.textLabel.text = title;
    cell.timeLabel.text = [NSDate dateDiff:date];
    cell.metaLabel.text = meta;
    
    return cell;
}

- (NSInteger)tableView:(AREmbeddedTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _articleList) {
        return _event.articles.count;
    } else {
        return _event.stories.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self rowHeightForIndexPath:indexPath];
}

- (CGFloat)rowHeightForIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
