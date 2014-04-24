//
//  ArticleCollectionViewCell.m
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ArticleCollectionViewCell.h"

@implementation ArticleCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat padding = 10;
        
        // Unlike most other cell views, the ArticleCollectionViewCell does not have full-cell images.
        CGSize imageSize = CGSizeMake(CGRectGetHeight(self.frame) - 2*padding,
                                      CGRectGetHeight(self.frame) - 2*padding);
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding,
                                                                       padding,
                                                                       imageSize.width,
                                                                       imageSize.height)];
        self.imageView.image = [UIImage imageNamed:@"placeholder"];
        [self addSubview:self.imageView];
        
        CGFloat titleLabelHeight = 40;
        CGFloat titleLabelOriginX = CGRectGetMinX(self.imageView.frame) + CGRectGetWidth(self.imageView.frame) + padding;
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.imageView.isHidden) {
        CGFloat padding = 10;
        CGRect titleFrame = self.titleLabel.frame;
        titleFrame.origin.x = padding;
        titleFrame.size.width = CGRectGetWidth(self.frame) - padding*2;
        self.titleLabel.frame = titleFrame;
        
        CGRect frame = self.timeLabel.frame;
        frame.origin.x = CGRectGetMinX(titleFrame);
        frame.size.width = CGRectGetWidth(titleFrame);
        self.timeLabel.frame = frame;
        self.metaLabel.frame = frame;
    }
}

@end
