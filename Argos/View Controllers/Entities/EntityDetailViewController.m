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
    AREmbeddedTableView *_storyList;
}

@end

@implementation EntityDetailViewController

- (EntityDetailViewController*)initWithEntity:(Entity*)entity;
{
    self = [super init];
    if (self) {
        // Load requested entity
        self.navigationItem.title = @"Entity";
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
    
    for (Story* story in _entity.stories) {
        [[RKObjectManager sharedManager] getObject:story path:story.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            _storyList.items = [NSMutableArray arrayWithArray:[_entity.stories allObjects]];
            [_storyList reloadData];
            [_storyList sizeToFit];
            [self adjustScrollViewHeight];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
    
    
    // Summary view
    CGPoint summaryOrigin = CGPointMake(bounds.origin.x, self.headerImageView.bounds.size.height);
    //NSString *summaryText = _entity.summary;
    NSString *summaryText = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi.";
    //self.summaryView = [[ARSummaryView alloc] initWithOrigin:summaryOrigin text:summaryText updatedAt:_story.updatedAt];
    self.summaryView = [[ARSummaryView alloc] initWithOrigin:summaryOrigin text:summaryText updatedAt:[NSDate date]];
    
    [self.scrollView addSubview:self.summaryView];
    
    // Title view
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0, bounds.origin.y, bounds.size.width - 32.0, self.headerImageView.bounds.size.height)];
    titleLabel.text = _entity.name;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"KlinicSlab-Book" size:20];
    titleLabel.numberOfLines = 0;
    [titleLabel sizeToFit];
    CGRect titleFrame = titleLabel.frame;
    titleFrame.origin.y = self.headerImageView.bounds.size.height - titleLabel.frame.size.height - 8.0;
    titleLabel.frame = titleFrame;
    [self.scrollView addSubview:titleLabel];
    
    
    // Story list header
    ARSectionHeaderView *sectionHeader = [[ARSectionHeaderView alloc] initWithTitle:[NSString stringWithFormat:@"Stories mentioning %@", _entity.name] withOrigin:CGPointMake(bounds.origin.x, self.summaryView.frame.origin.y + self.summaryView.frame.size.height)];
    [self.scrollView addSubview:sectionHeader];
    
    _storyList = [[AREmbeddedTableView alloc] initWithFrame:CGRectMake(bounds.origin.x, sectionHeader.frame.origin.y + sectionHeader.frame.size.height, bounds.size.width, 200.0)];
    
    
    [_storyList reloadData];
    [self.scrollView addSubview:_storyList];
    [_storyList sizeToFit];
    
    [self adjustScrollViewHeight];
}


@end
