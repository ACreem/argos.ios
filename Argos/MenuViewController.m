//
//  MenuViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/7/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "MenuViewController.h"
#import "EventListViewController.h"
#import "AppDelegate.h"

@interface MenuViewController () {
    NSMutableArray *_feeds;
    NSMutableArray *_settings;
    UINavigationController *_navigationController;
}

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    _navigationController = appDelegate.navigationController;
    self.viewDeckController.delegate = self;
    
    // Register the Cell class to use for table cells.
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: @"Cell"];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:1.0];
    
    // Hide empty cells
    self.tableView.tableFooterView = [UIView new];
    
    // Disable scrolling
    self.tableView.scrollEnabled = NO;
    
    // Set cell separator to full width, if necessary.
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.tableView setSeparatorColor:[UIColor colorWithRed:0.106 green:0.122 blue:0.149 alpha:1.0]];
    
    _feeds = [[NSMutableArray alloc] initWithObjects:@"Latest", @"Watching", nil];
    _settings = [[NSMutableArray alloc] initWithObjects:@"Settings", nil];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Bump the menu view down to fit the status bar underlayer.
    CGRect frame = [[self view] frame];
    //frame.size.height -= 20;
    frame.origin.y = 20;
    [[self view] setFrame:frame];
    
    // Remove extra table view top padding.
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewHeader=  [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 36)];
    viewHeader.backgroundColor = [UIColor colorWithRed:0.127 green:0.139 blue:0.178 alpha:1.0];
    
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, -2, tableView.frame.size.width - 14, 28)];
    sectionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0];
    sectionLabel.textColor = [UIColor colorWithRed:0.522 green:0.533 blue:0.557 alpha:1.0];
    
    if (section == 0) {
        sectionLabel.text = @"FEEDS";
    } else {
        sectionLabel.text = @"SETTINGS";
    }
    [viewHeader addSubview:sectionLabel];
    return viewHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _feeds.count;
    } else {
        return _settings.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString* title = @"";
    if (indexPath.section == 0) {
        title = [_feeds objectAtIndex:indexPath.row];
    } else {
        title = [_settings objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
    cell.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:1.0];
    cell.textLabel.textColor = [UIColor colorWithRed:0.929 green:0.929 blue:0.929 alpha:1.0];
    cell.imageView.image = [UIImage imageNamed:[title lowercaseString]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            [_navigationController pushViewController:[[EventListViewController alloc] initWithTitle:@"Watching" endpoint:@"/events"] animated:YES];
            [self.viewDeckController closeLeftViewAnimated:YES];
        }
    }
}

- (void)viewDeckController:(IIViewDeckController *)viewDeckController didChangeOffset:(CGFloat)offset orientation:(IIViewDeckOffsetOrientation)orientation panning:(BOOL)panning {
    NSLog(@"%f", offset);
}


@end
