//
//  StoryDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "StoryDetailViewController.h"
#import "EventDetailViewController.h"
#import "AREmbeddedTableView.h"
#import "Event.h"
#import "Entity.h"

@interface StoryDetailViewController () {
    Story *_story;
    AREmbeddedTableView *_eventList;
}

@end

@implementation StoryDetailViewController

- (StoryDetailViewController*)initWithStory:(Story*)story;
{
    self = [super init];
    if (self) {
        // Load requested story
        self.viewTitle = story.title;
        _story = story;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    // Set the header image,
    // downloading if necessary.
    if (_story.image) {
        [self setHeaderImage:_story.image];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSURL* imageUrl = [NSURL URLWithString:_story.imageUrl];
            NSError* error = nil;
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl options:NSDataReadingUncached error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage* image = [UIImage imageWithData:imageData];
                _story.image = image;
                [self setHeaderImage:_story.image];
            });
        });
    }
    
    self.totalItems = _story.events.count + _story.entities.count;
    
    // Summary view
    CGPoint summaryOrigin = CGPointMake(bounds.origin.x, self.headerView.bounds.size.height);
    self.summaryView = [[ARSummaryView alloc] initWithOrigin:summaryOrigin text:_story.summary updatedAt:_story.updatedAt];
    self.summaryView.delegate = self;
    [self.scrollView addSubview:self.summaryView];
    
    CGPoint eventListOrigin = CGPointMake(bounds.origin.x, self.summaryView.frame.origin.y + self.summaryView.frame.size.height);
    _eventList = [[AREmbeddedTableView alloc] initWithFrame:CGRectMake(bounds.origin.x, eventListOrigin.y, bounds.size.width, 200.0) title:@"Events"];
    _eventList.delegate = self;
    _eventList.dataSource = self;
    
    [_eventList reloadData];
    [self.scrollView addSubview:_eventList];
    [_eventList sizeToFit];
    [self fetchEvents];
    
    [self.scrollView sizeToFit];
    
    [self fetchEntities];
}

#pragma mark - Setup
- (void)fetchEntities
{
    // Fetch entities.
    __block NSUInteger fetched_entity_count = 0;
    for (Entity* entity in _story.entities) {
        [[RKObjectManager sharedManager] getObject:entity path:entity.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            fetched_entity_count++;
            
            self.loadedItems++;
            [self.progressView setProgress:self.loadedItems/self.totalItems animated:YES];
            
            if (fetched_entity_count == [_story.entities count]) {
                [self.summaryView setText:_story.summary withEntities:_story.entities];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
}

- (void)fetchEvents
{
    for (Event* event in _story.events) {
        __block NSUInteger fetched_event_count = 0;
        [[RKObjectManager sharedManager] getObject:event path:event.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            fetched_event_count++;
            
            self.loadedItems++;
            [self.progressView setProgress:self.loadedItems/self.totalItems animated:YES];
            
            if (fetched_event_count == [_story.events count]) {
                [_eventList reloadData];
                [_eventList sizeToFit];
                [self.scrollView sizeToFit];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(AREmbeddedTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [[_story.events allObjects] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[[EventDetailViewController alloc] initWithEvent:event] animated:YES];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(AREmbeddedTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Event *event = [[_story.events allObjects] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = event.title;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.imageView.image = [UIImage imageNamed:@"sample"];
    
    return cell;
}

- (NSInteger)tableView:(AREmbeddedTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _story.events.count;
}

@end
