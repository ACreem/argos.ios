//
//  ARHeaderView.h
//  Argos
//
//  Created by Francis Tseng on 3/13/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARHeaderView : UIView

@property (nonatomic, strong) UIView *gradientView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, assign) CGRect cachedFrame;

- (void)setImage:(UIImage*)image;

@end
