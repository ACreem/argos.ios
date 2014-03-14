//
//  CollectionView.h
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//
//  ==========================================
//  Abstract super class for collection views.
//  Configured to size to fit its content size
//  if its scrolling is disabled (as is the
//  case when this is part of an embedded
//  collection view controller).
//  ==========================================

@class CollectionHeaderView;

@interface CollectionView : UICollectionView

@property (nonatomic, strong) CollectionHeaderView* headerView;

@end
