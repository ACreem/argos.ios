//
//  ARCardCollectionViewCell.m
//  Argos
//
//  Created by Francis Tseng on 3/1/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARCardCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ARCardCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float xPadding = 10;
        float yPadding = 10;
        float aspectRatio = 1.6;
        
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width/aspectRatio)];
        
        self.imageView = [[UIImageView alloc] initWithFrame:headerView.frame];
        self.imageView.image = [UIImage imageNamed:@"placeholder"];
        [headerView addSubview:self.imageView];
        
        // Text gradient (so the text is readable)
        UIView *textGradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.imageView.frame.size.height)];
        CAGradientLayer *textGradient = [CAGradientLayer layer];
        textGradient.frame = textGradientView.bounds;
        textGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
        [textGradientView.layer insertSublayer:textGradient atIndex:0];
        textGradientView.alpha = 0.7;
        [headerView addSubview:textGradientView];
        
        float titleLabelHeight = 40;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding, headerView.frame.size.height - titleLabelHeight - yPadding, self.frame.size.width - 2*xPadding, titleLabelHeight)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont titleFontForSize:20];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [headerView addSubview:self.titleLabel];
        
        [self addSubview:headerView];
        
        UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height, self.frame.size.width, self.frame.size.height - headerView.frame.size.height)];
        CALayer *topBorder = [CALayer layer];
        float topBorderHeight = 4;
        topBorder.frame = CGRectMake(0, 0, self.frame.size.width, topBorderHeight);
        topBorder.backgroundColor = [UIColor actionColor].CGColor;
        [textView.layer addSublayer:topBorder];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding, yPadding/2 + topBorderHeight, self.frame.size.width - 2*xPadding, 20)];
        self.timeLabel.textColor = [UIColor mutedColor];
        self.timeLabel.font = [UIFont mediumFontForSize:10];
        [textView addSubview:self.timeLabel];
        
        float textLabelHeight = textView.frame.size.height - self.timeLabel.frame.size.height - yPadding - topBorderHeight;
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding, self.timeLabel.frame.size.height + topBorderHeight, self.frame.size.width - 2*xPadding, textLabelHeight)];
        self.textLabel.numberOfLines = 10;
        self.textLabel.font = [UIFont mediumFontForSize:14];
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.textLabel.textColor = [UIColor blackColor];
        [textView addSubview:self.textLabel];
        
        [self addSubview:textView];
        
        // HERE COMES THE DROP (shadow) ~~
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.shadowRadius = 0;
        self.layer.shadowOpacity = 0.3;
    }
    return self;
}

- (UIImage*)cropImage:(UIImage*)image
{
    // Crop to same aspect ratio as detail view header images.
    float aspectRatio = 1.6;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize dimensions = CGSizeMake(screenRect.size.width*2, (screenRect.size.width/aspectRatio)*2);
    UIImage *croppedImage = [image scaleToCoverSize:dimensions];
    croppedImage = [croppedImage cropToSize:dimensions usingMode:NYXCropModeCenter];
    return croppedImage;
}

- (void)setImageForEntity:(id<AREntity>)entity
{
    // Just re-use header images here.
    if (!entity.imageHeader) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            UIImage *croppedImage = [self cropImage:entity.image];
            entity.imageHeader = croppedImage;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = entity.imageHeader;
            });
        });
    } else {
        self.imageView.image = entity.imageHeader;
    }
}

@end
