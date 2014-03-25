//
//  CollectionViewController.h
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//
//  =====================================================
//  Abstract super class for collection view controllers.
//  This handles image downloading for its cells.
//  =====================================================

#import "CollectionView.h"
#import "CollectionViewCell.h"

@class BaseEntity;

@interface CollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate, UIScrollViewDelegate>

- (id)initWithCollectionViewLayout:(UICollectionViewLayout*)collectionViewLayout forEntityNamed:(NSString*)entityName;
- (id)initWithCollectionViewLayout:(UICollectionViewLayout*)collectionViewLayout forEntityNamed:(NSString*)entityName withPredicate:(NSPredicate*)predicate;
- (void)downloadImageForEntity:(BaseEntity*)entity forIndexPath:(NSIndexPath*)indexPath;
- (void)loadImagesForOnscreenRows;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) CollectionView *collectionView;
@property (nonatomic, strong) NSString *sortKey;
@property (nonatomic, strong) NSPredicate *predicate;

@end
