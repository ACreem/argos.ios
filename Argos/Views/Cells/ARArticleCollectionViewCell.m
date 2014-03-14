//
//  ARArticleCollectionViewCell.m
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARArticleCollectionViewCell.h"

@interface ARArticleCollectionViewCell ()
@end

@implementation ARArticleCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float padding = 10;
        
        // Unlike most other cell views, the ARArticleCollectionViewCell does not have full-cell images.
        CGSize imageSize = CGSizeMake(CGRectGetHeight(self.frame) - 2*padding,
                                      CGRectGetHeight(self.frame) - 2*padding);
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding,
                                                                       padding,
                                                                       imageSize.width,
                                                                       imageSize.height)];
        self.imageView.image = [UIImage imageNamed:@"placeholder"];
        [self addSubview:self.imageView];
        
        float titleLabelHeight = 40;
        float titleLabelOriginX = CGRectGetMinX(self.imageView.frame) + CGRectGetWidth(self.imageView.frame) + padding;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelOriginX,
                                                                    padding/2,
                                                                    CGRectGetWidth(self.frame) - titleLabelOriginX - padding,
                                                                    titleLabelHeight)];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont titleFontForSize:14];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.titleLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),
                                                                   CGRectGetHeight(self.titleLabel.frame) + padding,
                                                                   CGRectGetWidth(self.titleLabel.frame),
                                                                   20)];
        self.timeLabel.textColor = [UIColor mutedColor];
        self.timeLabel.font = [UIFont mediumFontForSize:9];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.timeLabel];
        
        self.metaLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame),
                                                                   CGRectGetMinY(self.timeLabel.frame),
                                                                   CGRectGetWidth(self.titleLabel.frame),
                                                                   20)];
        self.metaLabel.textColor = [UIColor mutedColor];
        self.metaLabel.font = [UIFont mediumFontForSize:9];
        self.metaLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.metaLabel];
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1.0f);
        bottomBorder.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05].CGColor;
        [self.layer addSublayer:bottomBorder];
    }
    return self;
}

@end
