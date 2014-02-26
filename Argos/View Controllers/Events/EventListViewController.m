//
//  EventListViewController.m
//  Argos
//
//  Created by Francis Tseng on 1/27/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EventListViewController.h"
#import "EventDetailViewController.h"
#import "ARFullCollectionViewCell.h"
#import "Event.h"

@interface EventListViewController ()

@property (strong, nonatomic) NSString *stream;

// For the intro pages.
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIFont *descFont;

@end

@implementation EventListViewController

- (id)initWithTitle:(NSString*)title stream:(NSString*)stream
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [flowLayout setSectionInset:UIEdgeInsetsZero];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //[flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];  // for horizontal scroll
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenRect.size.height -= (44 + 20); // navigation bar height + status bar height
    [flowLayout setItemSize:screenRect.size];
    
    self = [super initWithCollectionViewLayout:flowLayout forEntityNamed:@"Event"];
    if (self) {
        self.navigationItem.title = title;
        _stream = stream;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL userIsNew = YES;
    
    // If the user is new, show the intro/onboarding.
    if (userIsNew) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        
        _titleFont = [UIFont fontWithName:@"Graphik-LightItalic" size:24];
        _descFont = [UIFont fontWithName:@"Graphik-Light" size:17];
        
        EAIntroPage *page1 = [self createPageWithTitle:@"Know more with less" description:@"Argos helps you stay on top of the news without overwhelming you in content." imageNamed:@"onboarding00"];
        EAIntroPage *page2 = [self createPageWithTitle:@"Events" description:@"Keep up with everything that's happened in a story." imageNamed:@"onboarding01"];
        EAIntroPage *page3 = [self createPageWithTitle:@"Concepts" description:@"Quickly learn the concepts in a story." imageNamed:@"onboarding02"];
        EAIntroPage *page4 = [self createPageWithTitle:@"Entities" description:@"Understand the people, places, and organizations involved." imageNamed:@"onboarding03"];
        EAIntroPage *page5 = [self createPageWithTitle:@"Watch" description:@"Watch the stories that are important to you..." imageNamed:@"onboarding04"];
        EAIntroPage *page6 = [self createPageWithTitle:@"Trending" description:@"...and hear about the stories that are important for everyone else." imageNamed:@"onboarding05"];
        
        EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1, page2, page3, page4, page5, page6]];
        intro.delegate = self;
        [intro showInView:self.view animateDuration:0.0];
    }
    
    [self.collectionView registerClass:[ARFullCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.backgroundColor = [UIColor primaryColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.alwaysBounceVertical = YES; // necessary for pull-to-refresh
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    self.refreshControl.tintColor = [UIColor grayColor];
    
    [self loadData];
    [self.refreshControl beginRefreshing];
}

- (void)loadData
{
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/events" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self.refreshControl endRefreshing];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self.refreshControl endRefreshing];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An Error Has Occurred" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}

# pragma mark - UIControllerViewDelegate
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARFullCollectionViewCell *cell = (ARFullCollectionViewCell*)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self handleImageForEntity:(id)event forCell:cell atIndexPath:indexPath];
    
    cell.titleLabel.text = event.title;
    cell.textLabel.text = event.summary;
    cell.timeLabel.text = [NSDate dateDiff:event.updatedAt];
    
    return cell;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ARTableViewCell *cell = (ARTableViewCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    UIImageView *favoriteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favorite"]];
    [cell setSwipeGestureWithView:favoriteView color:[UIColor secondaryColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"favorited");
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favorited_icon"]];
        iconView.frame = CGRectMake(0,0,16,16);
        ARTableViewCell* arcell = (ARTableViewCell*)cell;
        [arcell.iconsView addSubview:iconView];
    }];
    
    UIImageView *watchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"watch"]];
    [cell setSwipeGestureWithView:watchView color:[UIColor secondaryColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"watched");
    }];
    
    
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self handleImageForEntity:(id)event forCell:cell atIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = event.title;
    cell.timeLabel.text = [NSDate dateDiff:event.updatedAt];
    
    return cell;
}
 */

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:[[EventDetailViewController alloc] initWithEvent:event] animated:YES];
}


# pragma mark - EAIntroDelegate

- (void)introDidFinish:(EAIntroView *)introView
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

// Helper for creating intro pages.
- (EAIntroPage*)createPageWithTitle:(NSString*)title description:(NSString*)description imageNamed:(NSString*)imageName
{
    float padding = 50;
    UIView *customView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    // Setup the title label.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, self.view.bounds.size.height/2 + 60, self.view.bounds.size.width - 2*padding, 60)];
    titleLabel.font = _titleFont;
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // Create a border the same width as the title.
    CALayer *bottomBorder = [CALayer layer];
    CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName: _titleFont}].width;
    bottomBorder.frame = CGRectMake(self.view.bounds.size.width/2 - width/2 - padding, titleLabel.frame.size.height - 20, width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.227 green:0.404 blue:0.984 alpha:1.0].CGColor;
    [titleLabel.layer addSublayer:bottomBorder];
    
    [customView addSubview:titleLabel];
    
    // Setup the description label.
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, titleLabel.frame.origin.y + titleLabel.frame.size.height, self.view.bounds.size.width - 2*padding, 60)];
    descLabel.font = _descFont;
    descLabel.text = description;
    descLabel.textColor = [UIColor whiteColor];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descLabel.numberOfLines = 0;
    [customView addSubview:descLabel];
    
    EAIntroPage *page = [EAIntroPage pageWithCustomView:customView];
    page.bgImage = [UIImage imageNamed:imageName];
    return page;
}

@end
