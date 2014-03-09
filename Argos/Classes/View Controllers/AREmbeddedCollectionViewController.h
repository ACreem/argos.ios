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

@interface AREmbeddedCollectionViewController : ARCollectionViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) ARCollectionHeaderView* headerView;

@end

@protocol AREmbeddedCollectionViewControllerDelegate

- (ARCollectionViewCell*)configureCell:(ARCollectionViewCell*)cell atIndexPath:(NSIndexPath*)indexPath forEmbeddedCollectionViewController:(AREmbeddedCollectionViewController*)embeddedCollectionViewController;
- (void)collectionView:(AREmbeddedCollectionViewController *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end
