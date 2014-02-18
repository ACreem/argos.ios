//
//  EntityDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/17/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EntityDetailViewController.h"
#import "StoryDetailViewController.h"
#import "AREmbeddedTableView.h"
#import "Story.h"

@interface EntityDetailViewController () {
    Entity *_entity;
    AREmbeddedTableView *_mentionList;
}

@end

@implementation EntityDetailViewController

- (EntityDetailViewController*)initWithEntity:(Entity*)entity;
{
    self = [super init];
    if (self) {
        // Load requested entity
        self.navigationItem.title = @"Entity";
        self.viewTitle = entity.name;
        _entity = entity;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[RKObjectManager sharedManager] getObject:_entity path:_entity.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
        [self setupView];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];
}

#pragma mark - Setup
- (void)setupView
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    // Summary view
    CGPoint summaryOrigin = CGPointMake(bounds.origin.x, self.headerView.bounds.size.height);
    //NSString *summaryText = _entity.summary;
    NSString *summaryText = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi.";
    //self.summaryView = [[ARSummaryView alloc] initWithOrigin:summaryOrigin text:summaryText updatedAt:_story.updatedAt];
    self.summaryView = [[ARSummaryView alloc] initWithOrigin:summaryOrigin text:summaryText updatedAt:_entity.updatedAt];
    
    [self.scrollView addSubview:self.summaryView];
    
    // Mentions (story) list header
    CGPoint mentionListOrigin = CGPointMake(bounds.origin.x, self.summaryView.frame.origin.y + self.summaryView.frame.size.height);
    _mentionList = [[AREmbeddedTableView alloc] initWithFrame:CGRectMake(bounds.origin.x, mentionListOrigin.y, bounds.size.width, 200.0) title:[NSString stringWithFormat:@"Stories mentioning %@", _entity.name]];
    _mentionList.delegate = self;
    _mentionList.dataSource = self;
    
    [_mentionList reloadData];
    [self.scrollView addSubview:_mentionList];
    [_mentionList sizeToFit];
    [self fetchMentions];
    
    [self.scrollView sizeToFit];
}

- (void)fetchMentions
{
    NSLog(@"fetching mentions");
    for (Story* story in _entity.stories) {
        [[RKObjectManager sharedManager] getObject:story path:story.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [_mentionList reloadData];
            [_mentionList sizeToFit];
            [self.scrollView sizeToFit];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(AREmbeddedTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Story *story = [[_entity.stories allObjects] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[[StoryDetailViewController alloc] initWithStory:story] animated:YES];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(AREmbeddedTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Story *story = [[_entity.stories allObjects] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = story.title;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.imageView.image = [UIImage imageNamed:@"sample"];
    
    return cell;
}

- (NSInteger)tableView:(AREmbeddedTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _entity.stories.count;
}


@end
