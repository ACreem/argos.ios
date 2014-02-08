//
//  EventDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/7/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EventDetailViewController.h"
#import "AGSectionHeaderView.h"
#import "AGTextButton.h"
#import "ArgosClient.h"

@interface EventDetailViewController () {
    NSMutableArray *_articles;
    UITableView *_articleList;
}

@end

@implementation EventDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Event";
    
    float textPaddingHorizontal = 16.0;
    float textPaddingVertical = 8.0;
    float headerImageHeight = 220.0;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height)];
    _scrollView.bounces = NO;
    
    // Header image
    _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sample"]];
    _headerImageView.frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, headerImageHeight);
    [self.view addSubview:_headerImageView];
    
    
    // Summary view
    UIView *summaryView = [[UIView alloc] initWithFrame:CGRectMake(bounds.origin.x, _headerImageView.bounds.size.height, bounds.size.width, 400.0)];
    summaryView.backgroundColor = [UIColor whiteColor];
    UILabel *summaryTitle = [[UILabel alloc] initWithFrame:CGRectMake(textPaddingHorizontal, textPaddingVertical, bounds.size.width - (textPaddingHorizontal*2), 20.0)];
    summaryTitle.text = @"SUMMARY";
    summaryTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    summaryTitle.textColor = [UIColor colorWithRed:0.573 green:0.58 blue:0.592 alpha:1.0];
    [summaryView addSubview:summaryTitle];
    
    UILabel *summary = [[UILabel alloc] initWithFrame:CGRectMake(textPaddingHorizontal, summaryTitle.bounds.origin.y + summaryTitle.bounds.size.height + textPaddingVertical*2, bounds.size.width - (textPaddingHorizontal*2), 200.0)];
    summary.text = @"Kerry meets with prince Saud al-Faisal for Syrian peace talks. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.";
    summary.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    summary.numberOfLines = 0;
    summary.lineBreakMode = NSLineBreakByWordWrapping;
    [summary sizeToFit];
    [summaryView addSubview:summary];
    
    // Story button
    AGTextButton *storyButton = [AGTextButton buttonWithTitle:@"View the full story"];
    CGRect buttonFrame = storyButton.frame;
    buttonFrame.origin.x = bounds.size.width/2 - storyButton.bounds.size.width/2;
    buttonFrame.origin.y = summary.frame.origin.y + summary.frame.size.height + textPaddingVertical*2;
    storyButton.frame = buttonFrame;
    
    [summaryView addSubview:storyButton];
    [summaryView sizeToFit];
    
    [_scrollView addSubview:summaryView];
    
    
    // Article list header
    AGSectionHeaderView *sectionHeader = [[AGSectionHeaderView alloc] initWithTitle:@"Sourced Articles" withOrigin:CGPointMake(bounds.origin.x, summaryView.bounds.origin.y + summaryView.bounds.size.height)];
    [_scrollView addSubview:sectionHeader];
    
    _articleList = [[UITableView alloc] initWithFrame:CGRectMake(bounds.origin.x, sectionHeader.frame.origin.y + sectionHeader.frame.size.height, bounds.size.width, 200.0)];
    _articleList.delegate = self;
    _articleList.dataSource = self;
    _articleList.scrollEnabled = NO;
    [_articleList registerClass: [UITableViewCell class] forCellReuseIdentifier: @"Cell"];
    // Set cell separator to full width, if necessary.
    if ([_articleList respondsToSelector:@selector(setSeparatorInset:)]) {
        [_articleList setSeparatorInset:UIEdgeInsetsZero];
    }
    [_scrollView addSubview:_articleList];
    
    _articles = [[NSMutableArray alloc] init];
    [self loadData];
    
    
   
    [self.view addSubview:_scrollView];
}

- (void)loadData
{
    [[ArgosClient sharedClient] GET:@"/events" parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        
        // Filter out existing items.
        NSMutableArray *newItems = [NSMutableArray arrayWithArray:responseObject];
        [newItems removeObjectsInArray:_articles];
        
        [_articles addObjectsFromArray:newItems];
        [_articleList reloadData];
        
        [self adjustScrollViewHeight];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection" message:@"Unable to reach home" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }];
}

- (void)adjustScrollViewHeight
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    // Auto size the table view.
    CGRect tableViewFrame = _articleList.frame;
    tableViewFrame.size.height = _articleList.contentSize.height;
    _articleList.frame = tableViewFrame;
    
    // Auto size scroll view height.
    // Start at 220 to accomodate for header image spacing.
    CGFloat scrollViewHeight = _headerImageView.bounds.size.height;
    for (UIView* view in _scrollView.subviews) {
        scrollViewHeight += view.frame.size.height;
    }
    [_scrollView setContentSize:(CGSizeMake(bounds.size.width, scrollViewHeight))];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _articles.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Should push to web view for the article.
    //[self.navigationController pushViewController:[[EventDetailViewController alloc] init] animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    // Configure the cell...
    NSDictionary *tempDict = [_articles objectAtIndex:indexPath.row];
    cell.textLabel.text = [tempDict objectForKey:@"title"];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.imageView.image = [UIImage imageNamed:@"sample"];
    
    return cell;
}

@end
