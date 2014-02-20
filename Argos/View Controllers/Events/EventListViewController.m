//
//  EventListViewController.m
//  Argos
//
//  Created by Francis Tseng on 1/27/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EventListViewController.h"
#import "EventDetailViewController.h"
#import "AREventTableViewCell.h"
#import "Event.h"

@interface EventListViewController () {
    NSString *_endpoint;
}

@end

@implementation EventListViewController

- (id)initWithTitle:(NSString*)title endpoint:(NSString*)endpoint
{
    self = [super init];
    if (self) {
        self.navigationItem.title = title;
        _endpoint = endpoint;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Hack to do back buttons w/o text.
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain target:nil action:nil];
 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
    
    // Set cell separator to full width, if necessary.
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Setup Pull-To-Refresh
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
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

- (void)downloadImageForEvent:(Event*)event forIndexPath:(NSIndexPath*)indexPath
{
    NSURL* imageUrl = [NSURL URLWithString:event.imageUrl];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSError* error = nil;
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl options:NSDataReadingUncached error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage* image = [UIImage imageWithData:imageData];
            event.image = image;
            
            // Crop the image
            // Need to double cell height for retina.
            UIImage *croppedImage = [image scaleToCoverSize:CGSizeMake(120, 120)];
            croppedImage = [image cropToSize:CGSizeMake(120, 120) usingMode:NYXCropModeCenter];
            
            // Update the UI
            UITableViewCell* tableCell =[self.tableView cellForRowAtIndexPath:indexPath];
            tableCell.imageView.image = croppedImage;
        });
    });
}

- (void)loadImagesForOnscreenRows
{
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths) {
        Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if (!event.image) {
            [self downloadImageForEvent:event forIndexPath:indexPath];
        }
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    AREventTableViewCell *cell = (AREventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSMutableArray *leftUtilityButtons = [NSMutableArray new];
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor primaryColor]
                                                     icon:[UIImage imageNamed:@"favorite"]];
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor primaryColor]
                                                     icon:[UIImage imageNamed:@"watch"]];
        
        cell = [[AREventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:CellIdentifier
                                        containingTableView:tableView
                                        leftUtilityButtons:leftUtilityButtons
                                        rightUtilityButtons:rightUtilityButtons];
        cell.delegate = self;
        
        // Adjust cell height
        [cell setCellHeight:[self rowHeightForIndexPath:indexPath]];
    }
    
    
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // If there's no cached image for this event,
    // consider loading it.
    if (!event.image) {
        // Only start loading images when scrolling stops.
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
            [self downloadImageForEvent:event forIndexPath:indexPath];
            
        // Otherwise use the placeholder image.
        } else {
            cell.imageView.image = [UIImage imageNamed:@"placeholder"];
        }
        
    // If there is a cached image, use it.
    } else {
        cell.imageView.image = event.image;
    }
    
    // Configure the cell...
    cell.textLabel.text = event.title;
    cell.timeLabel.text = [NSDate dateDiff:event.updatedAt];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self rowHeightForIndexPath:indexPath];
}

- (CGFloat)rowHeightForIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:[[EventDetailViewController alloc] initWithEvent:event] animated:YES];
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
                [button setImage:[UIImage imageNamed:@"watched"] forState:UIControlStateNormal];
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


#pragma mark - NSFetchedResultsControllerDelegate
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

/*
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}
*/

 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = event.title;
    cell.imageView.image = [UIImage imageNamed:@"sample"];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}



@end
