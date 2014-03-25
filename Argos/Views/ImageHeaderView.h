//
//  ImageHeaderView.h
//  Argos
//
//  Created by Francis Tseng on 3/13/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

@interface ImageHeaderView : UIView

@property (nonatomic, strong) UIView *gradientView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, assign) CGRect cachedFrame;

- (void)setHeaderImageViewWithImageUrl:(NSString *)url;

@end
