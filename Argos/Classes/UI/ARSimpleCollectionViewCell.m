//
//  ARSimpleCollectionViewCell.m
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARSimpleCollectionViewCell.h"

@interface ARSimpleCollectionViewCell ()
@property CGSize imageSize;
@end

@implementation ARSimpleCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float padding = 10;
        
        // Unlike most other cell views, the ARSimpleCollectionViewCell does not have full-cell images.
        _imageSize = CGSizeMake(self.frame.size.height - 2*padding, self.frame.size.height - 2*padding);
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding, padding, _imageSize.width, _imageSize.height)];
        self.imageView.image = [UIImage imageNamed:@"placeholder"];
        [self addSubview:self.imageView];
        
        float titleLabelHeight = 40;
        float titleLabelOriginx = self.imageView.frame.origin.x + self.imageView.frame.size.width + padding;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelOriginx, padding/2, self.frame.size.width - titleLabelOriginx - padding, titleLabelHeight)];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont titleFontForSize:14];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.titleLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.size.height + padding, self.titleLabel.frame.size.width, 20)];
        self.timeLabel.textColor = [UIColor mutedColor];
        self.timeLabel.font = [UIFont mediumFontForSize:9];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.timeLabel];
        
        self.metaLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x, self.timeLabel.frame.origin.y, self.titleLabel.frame.size.width, 20)];
        self.metaLabel.textColor = [UIColor mutedColor];
        self.metaLabel.font = [UIFont mediumFontForSize:9];
        self.metaLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.metaLabel];
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1.0f);
        bottomBorder.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05].CGColor;
        [self.layer addSublayer:bottomBorder];
    }
    return self;
}

// Since ARSimpleCollectionViewCell does not use full-cell images,
// cropping has to be handled a bit differently.
- (UIImage*)cropImage:(UIImage*)image
{
    CGSize dimensions = CGSizeMake(_imageSize.width*2, _imageSize.height*2);
    UIImage *croppedImage = [image scaleToCoverSize:dimensions];
    croppedImage = [croppedImage cropToSize:dimensions usingMode:NYXCropModeCenter];
    return croppedImage;
}

@end
