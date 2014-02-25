//
//  ARCollectionViewController.h
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARCollectionView.h"
#import "ARCollectionViewCell.h"

// Expect that Core Data entities processed by this
// view controller respond to these methods.
@protocol Entity
-(NSString*)imageUrl;
-(UIImage*)image;
-(void)setImage:(id)image;
@end

@interface ARCollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate, UIScrollViewDelegate>

- (id)initWithCollectionViewLayout:(UICollectionViewLayout*)collectionViewLayout forEntityNamed:(NSString*)entityName;
- (void)downloadImageForEntity:(id<Entity>)entity forIndexPath:(NSIndexPath*)indexPath;
- (void)handleImageForEntity:(id<Entity>)entity forCell:(ARCollectionViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;
- (void)loadImagesForOnscreenRows;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) ARCollectionView *collectionView;
@property (strong, nonatomic) NSString *sortKey;

@end
