//
//  EventDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/7/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EventDetailViewController.h"
#import "StoryDetailViewController.h"
#import "AGSectionHeaderView.h"
#import "AGTextButton.h"
#import "AGEmbeddedTableView.h"
#import "ArgosClient.h"

@interface EventDetailViewController () {
    CGRect bounds;
    NSInteger _eventId;
    NSDictionary *_event;
    AGEmbeddedTableView *_articleList;
}

@end

@implementation EventDetailViewController

- (EventDetailViewController*)initWithEventId:(NSInteger)eventId title:(NSString*)title
{
    self = [super init];
    if (self) {
        // Load requested event
        _eventId = eventId;
        self.navigationItem.title = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getEvent];
}

- (void)getEvent
{
    [[ArgosClient sharedClient] GET:[NSString stringWithFormat:@"/events/%i", _eventId]  parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        _event = responseObject;
        NSLog(@"%@", _event);

        [self setupView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection" message:@"Unable to reach home" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }];
}

- (void)setupView
{
    float textPaddingVertical = 8.0;
    bounds = [[UIScreen mainScreen] bounds];
    
    // Summary view
    CGPoint summaryOrigin = CGPointMake(bounds.origin.x, self.headerImageView.bounds.size.height);
    NSString *summaryText = @"Kerry meets with prince Saud al-Faisal for Syrian peace talks. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.";
    self.summaryView = [[AGSummaryView alloc] initWithOrigin:summaryOrigin text:summaryText updatedAt:_event[@"updated_at"]];
    
    // Story button
    AGTextButton *storyButton = [AGTextButton buttonWithTitle:@"View the full story"];
    CGRect buttonFrame = storyButton.frame;
    buttonFrame.origin.x = bounds.size.width/2 - storyButton.bounds.size.width/2;
    buttonFrame.origin.y = self.summaryView.summaryLabel.frame.origin.y + self.summaryView.summaryLabel.frame.size.height + textPaddingVertical*2;
    storyButton.frame = buttonFrame;
    [storyButton addTarget:self action:@selector(viewStory:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.summaryView addSubview:storyButton];
    [self.summaryView sizeToFit];
    
    [self.scrollView addSubview:self.summaryView];
    
    
    // Article list header
    AGSectionHeaderView *sectionHeader = [[AGSectionHeaderView alloc] initWithTitle:@"Articles" withOrigin:CGPointMake(bounds.origin.x, self.summaryView.bounds.origin.y + self.summaryView.bounds.size.height)];
    [self.scrollView addSubview:sectionHeader];
    
    _articleList = [[AGEmbeddedTableView alloc] initWithFrame:CGRectMake(bounds.origin.x, sectionHeader.frame.origin.y + sectionHeader.frame.size.height, bounds.size.width, 200.0)];
    
    // Filter out existing items.
    NSMutableArray *newItems = [NSMutableArray arrayWithArray:_event[@"members"]];
    [newItems removeObjectsInArray:_articleList.items];
    
    [_articleList.items addObjectsFromArray:newItems];
    [_articleList reloadData];
    
    [self.scrollView addSubview:_articleList];
    
    [_articleList sizeToFit];
    [self adjustScrollViewHeight];
}

- (void)viewStory:(id)sender
{
    [self.navigationController pushViewController:[[StoryDetailViewController alloc] init] animated:YES];
}

@end
