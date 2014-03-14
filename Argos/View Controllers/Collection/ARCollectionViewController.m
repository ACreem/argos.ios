//
//  ARCollectionViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARCollectionViewController.h"
#import "ImageDownloader.h"
#import "BaseEntity.h"

@interface ARCollectionViewController ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@end

@implementation ARCollectionViewController

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout*)collectionViewLayout forEntityNamed:(NSString*)entityName withPredicate:(NSPredicate*)predicate
{
    self = [super initWithCollectionViewLayout:collectionViewLayout];
    if (self) {
        _entityName = entityName;
        _sortKey = @"createdAt"; // default sort key
        _predicate = predicate;
    }
    return self;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout*)collectionViewLayout forEntityNamed:(NSString*)entityName
{
    return [self initWithCollectionViewLayout:(UICollectionViewLayout*)collectionViewLayout forEntityNamed:(NSString*)entityName withPredicate:(NSPredicate*)nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hack to do back buttons w/o text.
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.collectionView = [[ARCollectionView alloc] initWithFrame:screenRect collectionViewLayout:self.collectionViewLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}

# pragma mark - UICollectionViewDataSource
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ARCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

# pragma mark - NSFetchedResultsControllerDelegate
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
    // 0 = get all results.
    [fetchRequest setFetchBatchSize:0];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:_sortKey ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    if (_predicate) {
        [fetchRequest setPredicate:_predicate];
    }
    
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
    [self.collectionView reloadData];
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

# pragma mark - Image Loading
- (void)loadImagesForOnscreenRows
{
    NSArray *visiblePaths = [self.collectionView indexPathsForVisibleItems];
    for (NSIndexPath *indexPath in visiblePaths) {
        BaseEntity* entity = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if (!entity.image && entity.imageUrl) {
            [self downloadImageForEntity:entity forIndexPath:indexPath];
        }
    }
    
    // If only one cell is visible on screen,
    // i.e. we have full screen cells,
    // then preload the next and previous two images.
    // Assumes one section.
    if (visiblePaths.count == 1) {
        NSIndexPath* indexPath = visiblePaths.firstObject;
        int start = (int)indexPath.row;
        
        for (int i=1; i<=2; i++) {
            int next = start + i;
            if (next < self.fetchedResultsController.fetchedObjects.count) {
                NSIndexPath* nextIndexPath = [NSIndexPath indexPathForRow:next inSection:0];
                BaseEntity* entity = [self.fetchedResultsController objectAtIndexPath:nextIndexPath];
                if (!entity.image) {
                    [self downloadImageForEntity:entity forIndexPath:nextIndexPath];
                }
            }
        }
        
        for (int i=1; i<=2; i++) {
            int prev = start - i;
            if (prev >= 0) {
                NSIndexPath* prevIndexPath = [NSIndexPath indexPathForRow:prev inSection:0];
                BaseEntity* entity = [self.fetchedResultsController objectAtIndexPath:prevIndexPath];
                if (!entity.image) {
                    [self downloadImageForEntity:entity forIndexPath:prevIndexPath];
                }
            }
        }
        
    }
}

- (void)downloadImageForEntity:(BaseEntity*)entity forIndexPath:(NSIndexPath*)indexPath
{
    NSURL* imageUrl = [NSURL URLWithString:entity.imageUrl];
    
    ImageDownloader *imageDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader == nil) {
        imageDownloader = [[ImageDownloader alloc] initWithURL:imageUrl];
        [imageDownloader setCompletionHandler:^(UIImage *image) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                ARCollectionViewCell* cell = (ARCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
                entity.image = image;
                [cell setImageForEntity:entity];
            });
        }];
        [self.imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        [imageDownloader startDownload];
    }
}

- (void)handleImageForEntity:(BaseEntity*)entity forCell:(ARCollectionViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenRect.size.height -= ([UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height);
    
    // If there's no cached image for this event,
    // consider loading it.
    // Only entities with an imageUrl have an image to download.
    if (entity.imageUrl.length > 0) {
        if (!entity.image) {
            // Only start loading images when scrolling stops.
            if (self.collectionView.dragging == NO && self.collectionView.decelerating == NO) {
                [self downloadImageForEntity:entity forIndexPath:indexPath];
                
            // Otherwise use the placeholder image.
            } else {
                cell.imageView.image = [UIImage imageNamed:@"placeholder"];
            }
            
        // If there is a cached image, use it.
        } else {
            [cell setImageForEntity:entity];
        }
    } else {
        cell.imageView.image = [UIImage imageNamed:@"noimage"];
    }
}


@end
