//
//  AREmbeddedCollectionViewCell.m
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "AREmbeddedCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "BaseEntity.h"

@implementation AREmbeddedCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float xPadding = 10;
        float yPadding = 20;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                       CGRectGetWidth(self.frame),
                                                                       CGRectGetHeight(self.frame))];
        self.imageView.image = [UIImage imageNamed:@"placeholder"];
        [self addSubview:self.imageView];
        
        // Text gradient (so the text is readable)
        UIView *textGradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                            CGRectGetWidth(self.frame),
                                                                            CGRectGetHeight(self.frame))];
        CAGradientLayer *textGradient = [CAGradientLayer layer];
        textGradient.frame = textGradientView.bounds;
        textGradient.colors = @[ (id)[[UIColor clearColor] CGColor],
                                 (id)[[UIColor blackColor] CGColor] ];
        [textGradientView.layer insertSublayer:textGradient atIndex:0];
        textGradientView.alpha = 0.8;
        [self addSubview:textGradientView];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding,
                                                                   CGRectGetHeight(self.frame) - 10 - yPadding,
                                                                   CGRectGetWidth(self.frame) - 2*xPadding,
                                                                   20)];
        self.timeLabel.textColor = [UIColor mutedColor];
        self.timeLabel.font = [UIFont mediumFontForSize:10];
        [self addSubview:self.timeLabel];
        
        float titleLabelHeight = 40;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding,
                                                                    CGRectGetMinY(self.timeLabel.frame) - titleLabelHeight,
                                                                    CGRectGetWidth(self.frame) - 2*xPadding,
                                                                    titleLabelHeight)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont titleFontForSize:18];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setImageForEntity:(BaseEntity*)entity
{
    if (!entity.imageMid) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            UIImage *croppedImage = [self cropImage:entity.image];
            entity.imageMid = croppedImage;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = entity.imageMid;
            });
        });
    } else {
        self.imageView.image = entity.imageMid;
    }
}

@end
