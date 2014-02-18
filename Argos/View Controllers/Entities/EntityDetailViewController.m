//
//  EntityDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/17/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EntityDetailViewController.h"
#import "ARSectionHeaderView.h"
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

- (void)setupView
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    [self setupTitle];
    
    for (Story* story in _entity.stories) {
        [[RKObjectManager sharedManager] getObject:story path:story.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            _mentionList.items = [NSMutableArray arrayWithArray:[_entity.stories allObjects]];
            [_mentionList reloadData];
            [_mentionList sizeToFit];
            [self.scrollView sizeToFit];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
    
    // Summary view
    CGPoint summaryOrigin = CGPointMake(bounds.origin.x, self.headerView.bounds.size.height);
    //NSString *summaryText = _entity.summary;
    NSString *summaryText = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi.";
    //self.summaryView = [[ARSummaryView alloc] initWithOrigin:summaryOrigin text:summaryText updatedAt:_story.updatedAt];
    self.summaryView = [[ARSummaryView alloc] initWithOrigin:summaryOrigin text:summaryText updatedAt:[NSDate date]];
    
    [self.scrollView addSubview:self.summaryView];
    
    // Mentions (story) list header
    CGPoint mentionListOrigin = CGPointMake(bounds.origin.x, self.summaryView.frame.origin.y + self.summaryView.frame.size.height);
    _mentionList = [[AREmbeddedTableView alloc] initWithFrame:CGRectMake(bounds.origin.x, mentionListOrigin.y, bounds.size.width, 200.0) title:[NSString stringWithFormat:@"Stories mentioning %@", _entity.name]];
    
    [_mentionList reloadData];
    [self.scrollView addSubview:_mentionList];
    [_mentionList sizeToFit];
    
    [self.scrollView sizeToFit];
}


@end
