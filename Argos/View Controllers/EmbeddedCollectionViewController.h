//
//  EmbeddedCollectionViewController.h
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//
//  =======================================
//  A collection view controller which is
//  configured to be embedded in other view
//  controllers (e.g. creates a header for
//  itself).
//  =======================================

#import "CollectionViewController.h"
#import "CollectionHeaderView.h"

@class EmbeddedCollectionViewController;

@protocol EmbeddedCollectionViewControllerDelegate <NSObject>
- (CollectionViewCell*)configureCell:(CollectionViewCell*)cell atIndexPath:(NSIndexPath*)indexPath forEmbeddedCollectionViewController:(EmbeddedCollectionViewController*)embeddedCollectionViewController;
- (void)collectionView:(EmbeddedCollectionViewController *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface EmbeddedCollectionViewController : CollectionViewController

@property (nonatomic, assign) id <EmbeddedCollectionViewControllerDelegate> delegate;
@property (nonatomic, strong) CollectionHeaderView* headerView;

@end


