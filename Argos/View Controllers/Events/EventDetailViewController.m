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

@interface EventDetailViewController () {
    Event *_event;
    NSString *_title;
    AREmbeddedTableView *_articleList;
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

    
    // Summary view
    CGPoint summaryOrigin = CGPointMake(bounds.origin.x, self.headerImageView.bounds.size.height);
    NSString *summaryText = _event.summary;
    self.summaryView = [[ARSummaryView alloc] initWithOrigin:summaryOrigin text:summaryText updatedAt:_event.updatedAt];
    
    // Story button
    ARTextButton *storyButton = [ARTextButton buttonWithTitle:@"View the full story"];
    CGRect buttonFrame = storyButton.frame;
    buttonFrame.origin.x = bounds.size.width/2 - storyButton.bounds.size.width/2;
    buttonFrame.origin.y = self.summaryView.summaryTextView.frame.origin.y + self.summaryView.summaryTextView.frame.size.height + textPaddingVertical*2;
    storyButton.frame = buttonFrame;
    [storyButton addTarget:self action:@selector(viewStory:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.summaryView addSubview:storyButton];
    [self.summaryView sizeToFit];
    
    [self.scrollView addSubview:self.summaryView];
    
    // Title view
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, bounds.origin.y, bounds.size.width - 16.0, self.headerImageView.bounds.size.height)];
    titleLabel.text = _title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"KlinicSlab-Book" size:20];
    titleLabel.numberOfLines = 0;
    [titleLabel sizeToFit];
    CGRect titleFrame = titleLabel.frame;
    titleFrame.origin.y = self.headerImageView.bounds.size.height - titleLabel.frame.size.height - textPaddingVertical;
    titleLabel.frame = titleFrame;
    [self.scrollView addSubview:titleLabel];
    
    
    // Article list header
    ARSectionHeaderView *sectionHeader = [[ARSectionHeaderView alloc] initWithTitle:@"Articles" withOrigin:CGPointMake(bounds.origin.x, self.summaryView.frame.origin.y + self.summaryView.frame.size.height)];
    [self.scrollView addSubview:sectionHeader];
    
    _articleList = [[AREmbeddedTableView alloc] initWithFrame:CGRectMake(bounds.origin.x, sectionHeader.frame.origin.y + sectionHeader.frame.size.height, bounds.size.width, 200.0)];
    
    
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
