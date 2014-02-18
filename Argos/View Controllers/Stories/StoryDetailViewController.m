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
#import "Entity.h"

@interface StoryDetailViewController () {
    Story *_story;
    AREmbeddedTableView *_eventList;
    NSString *_summaryText;
}

@end

@implementation StoryDetailViewController

- (StoryDetailViewController*)initWithStory:(Story*)story;
{
    self = [super init];
    if (self) {
        // Load requested story
        self.navigationItem.title = @"Story";
        self.viewTitle = story.title;
        _story = story;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[RKObjectManager sharedManager] getObject:_story path:_story.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];
    
    // Fetch entities.
    // The view is setup once this is complete.
    __block NSUInteger fetched_entity_count = 0;
    for (Entity* entity in _story.entities) {
        [[RKObjectManager sharedManager] getObject:entity path:entity.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            fetched_entity_count++;
            
            if (fetched_entity_count == [_story.entities count]) {
                _summaryText = [self processSummary:_story.summary withEntities:_story.entities];
                [self setupView];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
    
}

- (void)setupView
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    [self setupTitle];
    
    for (Event* event in _story.events) {
        [[RKObjectManager sharedManager] getObject:event path:event.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            _eventList.items = [NSMutableArray arrayWithArray:[_story.events allObjects]];
            [_eventList reloadData];
            [_eventList sizeToFit];
            [self.scrollView sizeToFit];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
    
    // Summary view
    CGPoint summaryOrigin = CGPointMake(bounds.origin.x, self.headerView.bounds.size.height);
    self.summaryView = [[ARSummaryView alloc] initWithOrigin:summaryOrigin text:_summaryText updatedAt:_story.updatedAt];
    self.summaryView.delegate = self;
    [self.scrollView addSubview:self.summaryView];
    
    CGPoint eventListOrigin = CGPointMake(bounds.origin.x, self.summaryView.frame.origin.y + self.summaryView.frame.size.height);
    _eventList = [[AREmbeddedTableView alloc] initWithFrame:CGRectMake(bounds.origin.x, eventListOrigin.y, bounds.size.width, 200.0) title:@"Events"];
    
    [_eventList reloadData];
    [self.scrollView addSubview:_eventList];
    [_eventList sizeToFit];
    
    [self.scrollView sizeToFit];
}

@end
