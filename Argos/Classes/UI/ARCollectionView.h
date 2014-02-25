//
//  ARCollectionView.h
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARCollectionHeaderView.h"

@interface ARCollectionView : UICollectionView

@property (strong, nonatomic) ARCollectionHeaderView* headerView;

@end
