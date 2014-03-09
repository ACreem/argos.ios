//
//  ARCollectionViewCell.h
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//
//  ==========================================================
//  Abstract CollectionViewCell which others are based off of.
//  This handles its own image cropping.
//  ==========================================================

@interface ARCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UILabel *timeLabel;

- (UIImage*)cropImage:(UIImage*)image;

@end
