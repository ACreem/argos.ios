//
//  EventDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/7/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EventDetailViewController.h"
#import "StoryDetailViewController.h"
#import "ARSectionHeaderView.h"
#import "ARTextButton.h"
#import "AREmbeddedTableView.h"
#import "Article.h"
#import "Story.h"
#import "Entity.h"

@interface EventDetailViewController () {
    Event *_event;
    CGRect _bounds;
    NSString *_summaryText;
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
        self.navigationItem.title = @"Event";
        self.viewTitle = event.title;
        _event = event;
    }
    return self;
}

// NOTE this could use quite a bit of refactoring.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Update the event.
    [[RKObjectManager sharedManager] getObject:_event path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];
    
    // Fetch articles.
    // Need to keep track of how many articles have been fetched.
    // Note this is not the best way since it is possible that the number
    // of articles (or stories or entities) changes while these requests are made.
    __block NSUInteger fetched_article_count = 0;
    for (Article* article in _event.articles) {
        [[RKObjectManager sharedManager] getObject:article path:article.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            fetched_article_count++;
            
            if (fetched_article_count == [_event.articles count]) {
                _articleList.items = [NSMutableArray arrayWithArray:[_event.articles allObjects]];
                [_articleList reloadData];
                [_articleList sizeToFit];
                [self.scrollView sizeToFit];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
    
    // Fetch stories.
    __block NSUInteger fetched_story_count = 0;
    for (Story* story in _event.stories) {
        [[RKObjectManager sharedManager] getObject:story path:story.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            fetched_story_count++;
            
            if (fetched_story_count == [_event.stories count]) {
                _storyList.items = [NSMutableArray arrayWithArray:[_event.stories allObjects]];
                [_storyList reloadData];
                [_storyList sizeToFit];
                [self.scrollView sizeToFit];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
    
    // Fetch entities.
    // The view is setup once this is complete.
    __block NSUInteger fetched_entity_count = 0;
    for (Entity* entity in _event.entities) {
        [[RKObjectManager sharedManager] getObject:entity path:entity.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            fetched_entity_count++;
            
            if (fetched_entity_count == [_event.entities count]) {
                _summaryText = [self processSummary:_event.summary withEntities:_event.entities];
                [self setupView];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
    
}

- (void)setupView
{
    _bounds = [[UIScreen mainScreen] bounds];
    
    [self setupTitle];
    
    // Summary view
    CGPoint summaryOrigin = CGPointMake(_bounds.origin.x, self.headerView.bounds.size.height);
    self.summaryView = [[ARSummaryView alloc] initWithOrigin:summaryOrigin text:_summaryText updatedAt:_event.updatedAt];
    self.summaryView.delegate = self;
    [self setupStories];
    [self.scrollView addSubview:self.summaryView];

    [self setupArticles];
    
    [self.scrollView sizeToFit];
}

- (void)viewStory:(id)sender
{
    // Right now just fetching the first story.
    Story* story = [[_event.stories allObjects] firstObject];
    [self.navigationController pushViewController:[[StoryDetailViewController alloc] initWithStory:story] animated:YES];
}

- (void)setupStories
{
    // Story button
    // Show only if this event belongs to only one story.
    
    float textPaddingVertical = 8.0;
    if ([_event.stories count] == 1) {
        ARTextButton *storyButton = [ARTextButton buttonWithTitle:@"View the full story"];
        CGRect buttonFrame = storyButton.frame;
        buttonFrame.origin.x = _bounds.size.width/2 - storyButton.bounds.size.width/2;
        buttonFrame.origin.y = textPaddingVertical*2;
        
        UIView *actionsView = [[UIView alloc] initWithFrame:CGRectMake(_bounds.origin.x, self.summaryView.summaryWebView.frame.origin.y + self.summaryView.summaryWebView.frame.size.height, _bounds.size.width, buttonFrame.size.height + textPaddingVertical*2)];
        storyButton.frame = buttonFrame;
        [storyButton addTarget:self action:@selector(viewStory:) forControlEvents:UIControlEventTouchUpInside];
        [actionsView addSubview:storyButton];
        
        [self.summaryView addSubview:actionsView];
        
        // Otherwise show a list of stories.
    } else {
        _storyList = [[AREmbeddedTableView alloc] initWithFrame:CGRectMake(_bounds.origin.x, self.summaryView.frame.origin.y + self.summaryView.frame.size.height, _bounds.size.width, 200.0) title:@"Stories"];
        
        _storyList.items = [NSMutableArray arrayWithArray:[_event.stories allObjects]];
        [_storyList reloadData];
        [self.scrollView addSubview:_storyList];
        [_storyList sizeToFit];
    }
    [self.summaryView sizeToFit];
}

- (void)setupArticles
{
    CGPoint articleListOrigin;
    if (_storyList) {
        articleListOrigin = CGPointMake(_bounds.origin.x, _storyList.frame.origin.y + _storyList.frame.size.height);
    } else {
        articleListOrigin = CGPointMake(_bounds.origin.x, self.summaryView.frame.origin.y + self.summaryView.frame.size.height);
    }
    
    _articleList = [[AREmbeddedTableView alloc] initWithFrame:CGRectMake(_bounds.origin.x, articleListOrigin.y, _bounds.size.width, 200.0) title:@"Articles"];
    
    _articleList.items = [NSMutableArray arrayWithArray:[_event.articles allObjects]];
    [_articleList reloadData];
    [self.scrollView addSubview:_articleList];
    [_articleList sizeToFit];
}

@end
