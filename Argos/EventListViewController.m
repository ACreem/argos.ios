//
//  EventListViewController.m
//  Argos
//
//  Created by Francis Tseng on 1/27/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EventListViewController.h"
#import "SWTableViewCell.h"

@interface EventListViewController () {
    NSMutableArray *_events;
}

@end

@implementation EventListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"Latest";
    
    _manager = [AFHTTPRequestOperationManager manager];
    _events = [[NSMutableArray alloc] init];
    [_manager GET:@"http://localhost:5000/events" parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        [_events addObjectsFromArray:responseObject];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSMutableArray *leftUtilityButtons = [NSMutableArray new];
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:
            [UIColor colorWithRed:0.478 green:0.757 blue:0.471 alpha:1.0]
            icon:[UIImage imageNamed:@"favorite"]];
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:
            [UIColor colorWithRed:0.478 green:0.757 blue:0.471 alpha:1.0]
            icon:[UIImage imageNamed:@"watch"]];
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:
            [UIColor colorWithRed:0.478 green:0.757 blue:0.471 alpha:1.0]
            icon:[UIImage imageNamed:@"share"]];
        
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:CellIdentifier
                                        containingTableView:tableView
                                        leftUtilityButtons:leftUtilityButtons
                                        rightUtilityButtons:rightUtilityButtons];
        cell.delegate = self;
    }
    
    // Configure the cell...
    NSDictionary *tempDict = [_events objectAtIndex:indexPath.row];
    cell.textLabel.text = [tempDict objectForKey:@"title"];
    
    return cell;
}

#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            UIButton* button = [[cell rightUtilityButtons] objectAtIndex:index];
            if (button.tag != 1) {
                [button setImage:[UIImage imageNamed:@"favorited"] forState:UIControlStateNormal];
                [button setTag:1];
            } else {
                [button setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
                [button setTag:0];
            }
            
            //[cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            UIButton* button = [[cell rightUtilityButtons] objectAtIndex:index];
            if (button.tag != 1) {
                [button setImage:[UIImage imageNamed:@"watching"] forState:UIControlStateNormal];
                [button setTag:1];
            } else {
                [button setImage:[UIImage imageNamed:@"watch"] forState:UIControlStateNormal];
                [button setTag:0];
            }
            
            //[cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 2:
        {
            NSLog(@"share");
        }
        default:
            break;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
