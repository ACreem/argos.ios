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

@interface EventDetailViewController () {
    Event *_event;
    NSString *_title;
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
        _title = event.title;
        _event = event;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
}

- (void)setupView
{
    float textPaddingVertical = 8.0;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    [[RKObjectManager sharedManager] getObject:_event path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];
    
    for (Article* article in _event.articles) {
        [[RKObjectManager sharedManager] getObject:article path:article.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            _articleList.items = [NSMutableArray arrayWithArray:[_event.articles allObjects]];
            [_articleList reloadData];
            [_articleList sizeToFit];
            [self adjustScrollViewHeight];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
    
    for (Story* article in _event.stories) {
        [[RKObjectManager sharedManager] getObject:article path:article.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            _storyList.items = [NSMutableArray arrayWithArray:[_event.stories allObjects]];
            [_storyList reloadData];
            [_storyList sizeToFit];
            [self adjustScrollViewHeight];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
    
    // Title view
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, bounds.origin.y, bounds.size.width - 32.0, self.headerImageView.bounds.size.height)];
    titleLabel.text = _title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"KlinicSlab-Book" size:20];
    titleLabel.numberOfLines = 0;
    [titleLabel sizeToFit];
    CGRect titleFrame = titleLabel.frame;
    titleFrame.origin.y = self.headerImageView.bounds.size.height - titleLabel.frame.size.height - textPaddingVertical;
    titleLabel.frame = titleFrame;
    [self.scrollView addSubview:titleLabel];
    
    // Summary view
    CGPoint summaryOrigin = CGPointMake(bounds.origin.x, self.headerImageView.bounds.size.height);
    NSString *summaryText = _event.summary;
    self.summaryView = [[ARSummaryView alloc] initWithOrigin:summaryOrigin text:summaryText updatedAt:_event.updatedAt];
    
    // Story button
    // Show only if this event belongs to only one story.
    if ([_event.stories count] == 1) {
        ARTextButton *storyButton = [ARTextButton buttonWithTitle:@"View the full story"];
        CGRect buttonFrame = storyButton.frame;
        buttonFrame.origin.x = bounds.size.width/2 - storyButton.bounds.size.width/2;
        buttonFrame.origin.y = self.summaryView.summaryTextView.frame.origin.y + self.summaryView.summaryTextView.frame.size.height + textPaddingVertical*2;
        storyButton.frame = buttonFrame;
        [storyButton addTarget:self action:@selector(viewStory:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.summaryView addSubview:storyButton];
    // Otherwise show a list of stories.
    } else {
        // Story list header
        ARSectionHeaderView *storySectionHeader = [[ARSectionHeaderView alloc] initWithTitle:@"Stories" withOrigin:CGPointMake(bounds.origin.x, self.summaryView.frame.origin.y + self.summaryView.frame.size.height)];
        [self.scrollView addSubview:storySectionHeader];
        
        _storyList = [[AREmbeddedTableView alloc] initWithFrame:CGRectMake(bounds.origin.x, storySectionHeader.frame.origin.y + storySectionHeader.frame.size.height, bounds.size.width, 200.0)];
        
        _storyList.items = [NSMutableArray arrayWithArray:[_event.stories allObjects]];
        [_storyList reloadData];
        [self.scrollView addSubview:_storyList];
        [_storyList sizeToFit];
    }
    [self.summaryView sizeToFit];
    
    [self.scrollView addSubview:self.summaryView];
    
    // Article list header
    CGPoint articleListOrigin;
    if (_storyList) {
        articleListOrigin = CGPointMake(bounds.origin.x, _storyList.frame.origin.y + _storyList.frame.size.height);
    } else {
        articleListOrigin = CGPointMake(bounds.origin.x, self.summaryView.frame.origin.y + self.summaryView.frame.size.height);
    }
    ARSectionHeaderView *articleSectionHeader = [[ARSectionHeaderView alloc] initWithTitle:@"Articles" withOrigin:articleListOrigin];
    [self.scrollView addSubview:articleSectionHeader];
    
    _articleList = [[AREmbeddedTableView alloc] initWithFrame:CGRectMake(bounds.origin.x, articleSectionHeader.frame.origin.y + articleSectionHeader.frame.size.height, bounds.size.width, 200.0)];
    
    
    [_articleList reloadData];
    [self.scrollView addSubview:_articleList];
    [_articleList sizeToFit];
    
    [self adjustScrollViewHeight];
}

- (void)viewStory:(id)sender
{
    Story* story = [[_event.stories allObjects] firstObject];
    [self.navigationController pushViewController:[[StoryDetailViewController alloc] initWithStory:story] animated:YES];
}

- (void)share:(id)sender
{
    NSLog(@"shared");
}

@end
