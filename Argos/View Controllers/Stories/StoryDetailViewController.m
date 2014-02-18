//
//  StoryDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "StoryDetailViewController.h"
#import "ARSectionHeaderView.h"
#import "AREmbeddedTableView.h"
#import "Event.h"

@interface StoryDetailViewController () {
    Story *_story;
    NSString *_title;
    AREmbeddedTableView *_eventList;
}

@end

@implementation StoryDetailViewController

- (StoryDetailViewController*)initWithStory:(Story*)story;
{
    self = [super init];
    if (self) {
        // Load requested story
        self.navigationItem.title = @"Story";
        _title = story.title;
        _story = story;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    [[RKObjectManager sharedManager] getObject:_story path:_story.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
        [self setupView];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];
}

- (void)setupView
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    for (Event* event in _story.events) {
        [[RKObjectManager sharedManager] getObject:event path:event.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            _eventList.items = [NSMutableArray arrayWithArray:[_story.events allObjects]];
            [_eventList reloadData];
            [_eventList sizeToFit];
            [self adjustScrollViewHeight];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
    
    
    // Summary view
    CGPoint summaryOrigin = CGPointMake(bounds.origin.x, self.headerImageView.bounds.size.height);
    NSString *summaryText = _story.summary;
    self.summaryView = [[ARSummaryView alloc] initWithOrigin:summaryOrigin text:summaryText updatedAt:_story.updatedAt];
    
    [self.scrollView addSubview:self.summaryView];
    
    // Title view
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, bounds.origin.y, bounds.size.width - 32.0, self.headerImageView.bounds.size.height)];
    titleLabel.text = _title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"KlinicSlab-Book" size:20];
    titleLabel.numberOfLines = 0;
    [titleLabel sizeToFit];
    CGRect titleFrame = titleLabel.frame;
    titleFrame.origin.y = self.headerImageView.bounds.size.height - titleLabel.frame.size.height - 8.0;
    titleLabel.frame = titleFrame;
    [self.scrollView addSubview:titleLabel];
    
    
    // Event list header
    ARSectionHeaderView *sectionHeader = [[ARSectionHeaderView alloc] initWithTitle:@"Events" withOrigin:CGPointMake(bounds.origin.x, self.summaryView.frame.origin.y + self.summaryView.frame.size.height)];
    [self.scrollView addSubview:sectionHeader];
    
    _eventList = [[AREmbeddedTableView alloc] initWithFrame:CGRectMake(bounds.origin.x, sectionHeader.frame.origin.y + sectionHeader.frame.size.height, bounds.size.width, 200.0)];
    
    
    [_eventList reloadData];
    [self.scrollView addSubview:_eventList];
    [_eventList sizeToFit];
    
    [self adjustScrollViewHeight];
}

- (void)share:(id)sender
{
    NSLog(@"shared");
}

@end
