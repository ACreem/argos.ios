//
//  ARTableViewCell.h
//  Argos
//
//  Created by Francis Tseng on 2/9/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//
#import "MCSwipeTableViewCell.h"

@interface ARTableViewCell : MCSwipeTableViewCell

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *metaLabel;
@property (strong, nonatomic) UIView  *iconsView;

@end
