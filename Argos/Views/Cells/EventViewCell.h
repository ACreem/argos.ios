//
//  EventViewCell.h
//  Argos
//
//  Created by Francis Tseng on 4/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "BaseEntity.h"
#import "Concept.h"
#import "Event.h"
#import "Story.h"

@class BaseEntity;

@interface EventViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end
