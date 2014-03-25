//
//  ImageHeaderView.m
//  Argos
//
//  Created by Francis Tseng on 3/13/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ImageHeaderView.h"
#import "GPUImage.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface ImageHeaderView ()
@property (nonatomic, strong) UIView *textGradientView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CAGradientLayer *textGradientLayer;
@property (nonatomic, assign) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) GPUImageGaussianBlurFilter *blurFilter;
@end

@implementation ImageHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cachedFrame = frame;
        
        UIImage* headerImage = [UIImage imageNamed:@"placeholder"];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView = [[UIImageView alloc] initWithImage:headerImage];
        _imageView.frame = frame;
        [self addSubview:_imageView];
        
        // Header image blur
        _blurredImageView = [[UIImageView alloc] initWithFrame:frame];
        _blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
        _blurredImageView.frame = frame;
        _blurredImageView.alpha = 0.0;
        [self addSubview:_blurredImageView];
        
        // Text gradient (so the text is readable)
        _textGradientView = [[UIView alloc] initWithFrame:frame];
        CAGradientLayer *textGradient = [CAGradientLayer layer];
        textGradient.frame = _textGradientView.bounds;
        textGradient.colors = @[ (id)[[UIColor clearColor] CGColor],
                                 (id)[[UIColor blackColor] CGColor] ];
        [_textGradientView.layer addSublayer:textGradient];
        _textGradientLayer = textGradient;
        _textGradientView.alpha = 0.6;
        [self addSubview:_textGradientView];
        
        // Gradient image overlay (for scrolling)
        _gradientView = [[UIView alloc] initWithFrame:frame];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = _gradientView.bounds;
        gradient.colors = @[ (id)[[UIColor clearColor] CGColor],
                             (id)[[UIColor blackColor] CGColor],
                             (id)[[UIColor blackColor] CGColor],
                             (id)[[UIColor blackColor] CGColor],
                             (id)[[UIColor blackColor] CGColor] ];
        [_gradientView.layer addSublayer:gradient];
        _gradientLayer = gradient;
        _gradientView.alpha = 0.0;
        [self addSubview:_gradientView];
        
        self.blurFilter = [GPUImageGaussianBlurFilter new];
    }
    return self;
}

- (void)setHeaderImageViewWithImageUrl:(NSString *)url {
    __weak typeof(self) weakSelf = self;
    
    [self.imageView setImageWithURL:[NSURL URLWithString:url]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                              UIImage *blurred = [weakSelf.blurFilter imageByFilteringImage:image];
                              [weakSelf.blurredImageView setImage:blurred];
                              
                              [weakSelf.imageView setContentMode:UIViewContentModeScaleAspectFill];
                              [weakSelf.blurredImageView setContentMode:UIViewContentModeScaleAspectFill];
                          }];
}

- (void)setImage:(UIImage*)image
{
    _image = image;
    [self.imageView setImage:image];
    
    [self.blurredImageView setImage:[self.blurFilter imageByFilteringImage:image]];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.blurredImageView.frame = frame;
    self.imageView.frame = frame;
    self.textGradientView.frame = frame;
    self.gradientView.frame = frame;
    
    // We have to manually update the text gradient layer's frame.
    // CALayers animate by default, so we have to temporarily disable this.
    [CATransaction setDisableActions:YES];
    self.textGradientLayer.frame = self.textGradientView.bounds;
    self.gradientLayer.frame = self.gradientView.bounds;
    [CATransaction setDisableActions:NO];
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    self.blurredImageView.center = center;
    self.imageView.center = center;
    self.textGradientView.center = center;
    self.gradientView.center = center;
}

@end
