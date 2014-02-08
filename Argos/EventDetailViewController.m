//
//  EventDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/7/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EventDetailViewController.h"
#import "SectionHeaderView.h"

@interface EventDetailViewController () {
    NSMutableArray *_articles;
}

@end

@implementation EventDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Event";
    
    float textPaddingHorizontal = 16.0;
    float textPaddingVertical = 8.0;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height)];
    scrollView.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:1.0];
    
    // Header image
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sample"]];
    headerImageView.frame = [[UIScreen mainScreen] bounds];
    headerImageView.frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 220.0);
    [scrollView addSubview:headerImageView];
    
    
    // Summary view
    UIView *summaryView = [[UIView alloc] initWithFrame:CGRectMake(bounds.origin.x, headerImageView.bounds.size.height, bounds.size.width, 400.0)];
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
    [scrollView addSubview:summaryView];
    
    // Article list header
    SectionHeaderView *sectionHeader = [[SectionHeaderView alloc] initWithTitle:@"Sourced Articles" withOrigin:CGPointMake(bounds.origin.x, summaryView.bounds.origin.y + summaryView.bounds.size.height)];
    [scrollView addSubview:sectionHeader];
    
    
    UITableView *articleList = [[UITableView alloc] initWithFrame:CGRectMake(bounds.origin.x, sectionHeader.frame.origin.y + sectionHeader.frame.size.height, bounds.size.width, 200.0)];
    articleList.delegate = self;
    articleList.dataSource = self;
    [articleList registerClass: [UITableViewCell class] forCellReuseIdentifier: @"Cell"];
    // Set cell separator to full width, if necessary.
    if ([articleList respondsToSelector:@selector(setSeparatorInset:)]) {
        [articleList setSeparatorInset:UIEdgeInsetsZero];
    }
    [scrollView addSubview:articleList];
    
    // Auto size scroll view height.
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in scrollView.subviews) {
        scrollViewHeight += view.frame.size.height;
    }
    [scrollView setContentSize:(CGSizeMake(bounds.size.width, scrollViewHeight))];
    
    [self.view addSubview:scrollView];
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
