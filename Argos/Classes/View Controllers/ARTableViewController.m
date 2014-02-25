//
//  ARTableViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/22/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARTableViewController.h"

@interface ARTableViewController () {
    NSString *_title;
    NSString *_entityName;
}
@end

@implementation ARTableViewController

- (id)initWithEntityNamed:(NSString*)entityName {
    self = [super init];
    if (self) {
        _entityName = entityName;
    }
    return self;
}

- (id)initAsEmbeddedWithEntityNamed:(NSString*)entityName withTitle:(NSString*)title
{
    self = [self initWithEntityNamed:entityName];
    if (self) {
        _title = title;
        self.embedded = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hack to do back buttons w/o text.
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.tableView = [[ARTableView alloc] initWithFrame:screenRect];
    
    if (self.embedded) {
        self.tableView.scrollEnabled = NO;
    }
}


# pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ARTableViewCell *cell = (ARTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[ARTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        // Setting the background color of the cell.
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    [cell setDefaultColor:[UIColor secondaryColor]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

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

- (UIView *)tableView:(ARTableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.embedded) {
        tableView.headerView = [[ARSectionHeaderView alloc] initWithTitle:_title withOrigin:CGPointMake(0, 0)];
        return tableView.headerView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.embedded) {
        return 40;
    }
    return 0;
}


#pragma mark - NSFetchedResultsControllerDelegate
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:_entityName inManagedObjectContext:self.managedObjectContext];
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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
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


# pragma mark Image Loading
- (void)loadImagesForOnscreenRows
{
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths) {
        id<Entity> entity = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if (!entity.image) {
            [self downloadImageForEntity:entity forIndexPath:indexPath];
        }
    }
}

- (void)downloadImageForEntity:(id<Entity>)entity forIndexPath:(NSIndexPath*)indexPath
{
    NSURL* imageUrl = [NSURL URLWithString:entity.imageUrl];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSError* error = nil;
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl options:NSDataReadingUncached error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage* image = [UIImage imageWithData:imageData];
            entity.image = image;
            
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

- (void)handleImageForEntity:(id<Entity>)entity forCell:(ARTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    // If there's no cached image for this event,
    // consider loading it.
    if (!entity.image) {
        // Only start loading images when scrolling stops.
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
            [self downloadImageForEntity:entity forIndexPath:indexPath];
            
        // Otherwise use the placeholder image.
        } else {
            cell.imageView.image = [UIImage imageNamed:@"placeholder"];
        }
        
    // If there is a cached image, use it.
    } else {
        cell.imageView.image = entity.image;
    }
}

@end
