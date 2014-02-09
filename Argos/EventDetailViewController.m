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
#import "AGTableView.h"
#import "ArgosClient.h"

@interface EventDetailViewController () {
    CGRect bounds;
    AGTableView *_articleList;
}

@end

@implementation EventDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Kerry Leads Peace Talks";
    
    float textPaddingVertical = 8.0;
    bounds = [[UIScreen mainScreen] bounds];
    
    // Summary view
    CGPoint summaryOrigin = CGPointMake(bounds.origin.x, self.headerImageView.bounds.size.height);
    NSString *summaryText = @"Kerry meets with prince Saud al-Faisal for Syrian peace talks. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.";
    self.summaryView = [[AGSummaryView alloc] initWithOrigin:summaryOrigin withText:summaryText];
    
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
    AGSectionHeaderView *sectionHeader = [[AGSectionHeaderView alloc] initWithTitle:@"Sourced Articles" withOrigin:CGPointMake(bounds.origin.x, self.summaryView.bounds.origin.y + self.summaryView.bounds.size.height)];
    [self.scrollView addSubview:sectionHeader];
    
    _articleList = [[AGTableView alloc] initWithFrame:CGRectMake(bounds.origin.x, sectionHeader.frame.origin.y + sectionHeader.frame.size.height, bounds.size.width, 200.0)];
    [self.scrollView addSubview:_articleList];
    
    [self loadArticleData];
}

- (void)loadArticleData
{
    [[ArgosClient sharedClient] GET:@"/events" parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        
        // Filter out existing items.
        NSMutableArray *newItems = [NSMutableArray arrayWithArray:responseObject];
        [newItems removeObjectsInArray:_articleList.items];
        
        [_articleList.items addObjectsFromArray:newItems];
        [_articleList reloadData];
        
        [_articleList sizeToFit];
        [self adjustScrollViewHeight];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection" message:@"Unable to reach home" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }];
}

- (void)viewStory:(id)sender
{
    [self.navigationController pushViewController:[[StoryDetailViewController alloc] init] animated:YES];
}

@end
