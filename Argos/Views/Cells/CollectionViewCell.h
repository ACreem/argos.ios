//
//  CollectionViewCell.h
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//
//  ==========================================================
//  Abstract CollectionViewCell which others are based off of.
//  This handles its own image cropping.
//  ==========================================================

@class BaseEntity;

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *timeLabel;

- (UIImage*)cropImage:(UIImage*)image;
- (void)setImageForEntity:(BaseEntity*)entity;

@end
