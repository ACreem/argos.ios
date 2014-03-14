//
//  MenuViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/7/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "MenuViewController.h"
#import "StreamViewController.h"
#import "AppDelegate.h"
#import "SearchViewController.h"

@interface MenuViewController () {
    NSMutableArray *_streams;
    NSMutableArray *_user;
    NSMutableArray *_search;
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
    
    _streams = [[NSMutableArray alloc] initWithObjects:@"Trending", @"Watching", @"Latest", nil];
    _user = [[NSMutableArray alloc] initWithObjects:@"Bookmarks", @"Settings", @"Logout", nil];
    _search = [[NSMutableArray alloc] initWithObjects:@"Search", nil];
    [self.tableView reloadData];
 
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Bump the menu view down to fit the status bar underneath.
    CGRect frame = [[self view] frame];
    frame.origin.y = 20;
    [[self view] setFrame:frame];
    
    // Remove extra table view top padding.
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewHeader=  [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 36)];
    viewHeader.backgroundColor = [UIColor actionColor];
    
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, -2, tableView.frame.size.width - 14, 28)];
    sectionLabel.font = [UIFont boldFontForSize:10];
    sectionLabel.textColor = [UIColor whiteColor];
    
    switch (section) {
        case 0:
            // The Search section has no header.
            sectionLabel.text = @"";
            break;
        case 1:
            sectionLabel.text = @"FEEDS";
            break;
        case 2:
            sectionLabel.text = @"YOU";
            break;
    }
    [viewHeader addSubview:sectionLabel];
    return viewHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        // The Search section has no header.
        return 0;
    } else {
        return 24;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _search.count;
            break;
        case 1:
            return _streams.count;
            break;
        case 2:
            return _user.count;
            break;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString* title = @"";
    switch (indexPath.section) {
        case 0:
            title = [_search objectAtIndex:indexPath.row];
            break;
        case 1:
            title = [_streams objectAtIndex:indexPath.row];
            break;
        case 2:
            title = [_user objectAtIndex:indexPath.row];
            break;
    }
    
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont lightFontForSize:16];
    cell.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:1.0];
    cell.textLabel.textColor = [UIColor colorWithRed:0.929 green:0.929 blue:0.929 alpha:1.0];
    cell.imageView.image = [UIImage imageNamed:[title lowercaseString]];
    
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor mutedAltColor];
    }
    
    // For setting the selected/tapped background color.
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.141 green:0.49 blue:0.875 alpha:1.0];
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            SearchViewController *searchViewController = [[SearchViewController alloc] init];
            [_navigationController pushViewController:searchViewController animated:YES];
            [self.viewDeckController closeLeftViewAnimated:YES];
            break;
        }
        case 1: {
            StreamViewController *svc;
            //[_navigationController popToRootViewControllerAnimated:NO];
            switch (indexPath.row) {
                case 0:
                    svc = [[StreamViewController alloc] initWithStream:kArgosTrendingStream];
                    break;
                case 1:
                    svc = [[StreamViewController alloc] initWithStream:kArgosWatchingStream];
                    break;
                case 2:
                    svc = [[StreamViewController alloc] initWithStream:kArgosLatestStream];
                    break;
            }
            svc.managedObjectContext = [[ARObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
            [_navigationController pushViewController:svc animated:YES];
        }
        case 2:
            switch (indexPath.row) {
                case 0: {
                    // Bookmarks.
                    StreamViewController *svc = [[StreamViewController alloc] initWithStream:kArgosBookmarkedStream];
                    svc.managedObjectContext = [[ARObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
                    [_navigationController pushViewController:svc animated:YES];
                    break;
                }
                case 1:
                    // Settings.
                    break;
                case 2:
                    // Logout.
                    [[ARObjectManager sharedManager] logoutCurrentUser];
                    
                    [_navigationController setNavigationBarHidden:YES];
                    [_navigationController popToRootViewControllerAnimated:YES];
                    
                    // Remove the menu!
                    [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
                        self.viewDeckController.leftController = nil;
                    }];
                    break;
            }
    }
    
    [self.viewDeckController closeLeftViewAnimated:YES];
}


@end
