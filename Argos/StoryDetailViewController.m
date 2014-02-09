//
//  StoryDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "StoryDetailViewController.h"
#import "AGSectionHeaderView.h"
#import "AGTableView.h"
#import "ArgosClient.h"

@interface StoryDetailViewController () {
    CGRect bounds;
    AGTableView *_eventList;
}

@end

@implementation StoryDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Syrian Peace";
    
    bounds = [[UIScreen mainScreen] bounds];
    
    // Summary view
    CGPoint summaryOrigin = CGPointMake(bounds.origin.x, self.headerImageView.bounds.size.height);
    NSString *summaryText = @"Kerry meets with prince Saud al-Faisal for Syrian peace talks. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.";
    self.summaryView = [[AGSummaryView alloc] initWithOrigin:summaryOrigin text:summaryText];
    [self.summaryView sizeToFit];
    [self.scrollView addSubview:self.summaryView];
    
    // Event list header
    AGSectionHeaderView *sectionHeader = [[AGSectionHeaderView alloc] initWithTitle:@"Events" withOrigin:CGPointMake(bounds.origin.x, self.summaryView.bounds.origin.y + self.summaryView.bounds.size.height)];
    [self.scrollView addSubview:sectionHeader];
    
    _eventList = [[AGTableView alloc] initWithFrame:CGRectMake(bounds.origin.x, sectionHeader.frame.origin.y + sectionHeader.frame.size.height, bounds.size.width, 200.0)];
    [self.scrollView addSubview:_eventList];
    
    [self loadArticleData];
}

- (void)loadArticleData
{
    [[ArgosClient sharedClient] GET:@"/events" parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        
        // Filter out existing items.
        NSMutableArray *newItems = [NSMutableArray arrayWithArray:responseObject];
        [newItems removeObjectsInArray:_eventList.items];
        
        [_eventList.items addObjectsFromArray:newItems];
        [_eventList reloadData];
        
        [_eventList sizeToFit];
        [self adjustScrollViewHeight];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection" message:@"Unable to reach home" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }];
}

@end
