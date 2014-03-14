//
//  AREmbeddedCollectionViewController.h
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

#import "ARCollectionViewController.h"
#import "ARCollectionHeaderView.h"

@class AREmbeddedCollectionViewController;

@protocol AREmbeddedCollectionViewControllerDelegate <NSObject>
- (ARCollectionViewCell*)configureCell:(ARCollectionViewCell*)cell atIndexPath:(NSIndexPath*)indexPath forEmbeddedCollectionViewController:(AREmbeddedCollectionViewController*)embeddedCollectionViewController;
- (void)collectionView:(AREmbeddedCollectionViewController *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface AREmbeddedCollectionViewController : ARCollectionViewController

@property (nonatomic, assign) id <AREmbeddedCollectionViewControllerDelegate> delegate;
@property (nonatomic, strong) ARCollectionHeaderView* headerView;

@end


