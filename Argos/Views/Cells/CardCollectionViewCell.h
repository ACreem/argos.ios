//
//  CardCollectionViewCell.h
//  Argos
//
//  Created by Francis Tseng on 3/1/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//
//  ====================================================
//  A view cell which is configured to look like a card.
//  ====================================================

#import "Event.h"

@interface CardCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *timeLabel;

- (void) configureCellForEvent:(Event *)event;

@end
