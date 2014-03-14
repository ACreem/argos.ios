//
//  ARImageHeaderView.m
//  Argos
//
//  Created by Francis Tseng on 3/13/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARImageHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@interface ARImageHeaderView ()
@property (nonatomic, strong) UIView *textGradientView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ARImageHeaderView

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
        UIImage* blurred = [headerImage gaussianBlurWithBias:0];
        _blurredImageView = [[UIImageView alloc] initWithImage:blurred];
        _blurredImageView.frame = frame;
        _blurredImageView.alpha = 0.0;
        [self addSubview:_blurredImageView];
        
        // Text gradient (so the text is readable)
        _textGradientView = [[UIView alloc] initWithFrame:frame];
        _textGradientView.contentMode = UIViewContentModeScaleAspectFill;
        CAGradientLayer *textGradient = [CAGradientLayer layer];
        textGradient.frame = _textGradientView.bounds;
        textGradient.colors = @[ (id)[[UIColor clearColor] CGColor],
                                 (id)[[UIColor blackColor] CGColor] ];
        [_textGradientView.layer insertSublayer:textGradient atIndex:0];
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
        [_gradientView.layer insertSublayer:gradient atIndex:0];
        _gradientView.alpha = 0.0;
        [self addSubview:_gradientView];
    }
    return self;
}

- (void)setImage:(UIImage*)image
{
    [_imageView setImage:image];
    
    UIImage* blurred = [image gaussianBlurWithBias:0];
    [_blurredImageView setImage:blurred];
}

@end
