//
//  CardCollectionViewCell.m
//  Argos
//
//  Created by Francis Tseng on 3/1/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "CardCollectionViewCell.h"
#import "BaseEntity.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CardCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat xPadding = 10;
        CGFloat yPadding = 10;
        CGFloat aspectRatio = 1.6;
        
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                      CGRectGetWidth(self.frame),
                                                                      CGRectGetWidth(self.frame)/aspectRatio)];
        
        self.imageView = [[UIImageView alloc] initWithFrame:headerView.frame];
        self.imageView.image = [UIImage imageNamed:@"placeholder"];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [headerView addSubview:self.imageView];
        
        // Text gradient (so the text is readable)
        UIView *textGradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                            CGRectGetWidth(self.frame),
                                                                            CGRectGetHeight(self.imageView.frame))];
        CAGradientLayer *textGradient = [CAGradientLayer layer];
        textGradient.frame = textGradientView.bounds;
        textGradient.colors = @[ (id)[[UIColor clearColor] CGColor],
                                 (id)[[UIColor blackColor] CGColor] ];
        [textGradientView.layer insertSublayer:textGradient atIndex:0];
        textGradientView.alpha = 0.7;
        [headerView addSubview:textGradientView];
        
        CGFloat titleLabelHeight = 40;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding,
                                                                    CGRectGetHeight(headerView.frame) - titleLabelHeight - yPadding,
                                                                    CGRectGetWidth(self.frame) - 2*xPadding, titleLabelHeight)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont titleFontForSize:20];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [headerView addSubview:self.titleLabel];
        
        [self addSubview:headerView];
        
        UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    CGRectGetHeight(headerView.frame),
                                                                    CGRectGetWidth(self.frame),
                                                                    CGRectGetHeight(self.frame) - CGRectGetHeight(headerView.frame))];
        CALayer *topBorder = [CALayer layer];
        CGFloat topBorderHeight = 4;
        topBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), topBorderHeight);
        topBorder.backgroundColor = [UIColor actionColor].CGColor;
        [textView.layer addSublayer:topBorder];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding,
                                                                   yPadding/2 + topBorderHeight,
                                                                   CGRectGetWidth(self.frame) - 2*xPadding,
                                                                   20)];
        self.timeLabel.textColor = [UIColor mutedColor];
        self.timeLabel.font = [UIFont mediumFontForSize:10];
        [textView addSubview:self.timeLabel];
        
        CGFloat textLabelHeight = CGRectGetHeight(textView.frame) - CGRectGetHeight(self.timeLabel.frame) - yPadding - topBorderHeight;
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding,
                                                                   CGRectGetHeight(self.timeLabel.frame) + topBorderHeight,
                                                                   CGRectGetWidth(self.frame) - 2*xPadding,
                                                                   textLabelHeight)];
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

- (void)setImageForEntity:(BaseEntity*)entity
{
    [_imageView setImageWithURL:[NSURL URLWithString:entity.imageUrl]
               placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
}

- (void)configureCellForEvent:(Event *)event {
    _titleLabel.text = event.title;
    _textLabel.text = event.summary;
    _timeLabel.text = [event.updatedAt timeAgo];
    
    [_imageView setImageWithURL:[NSURL URLWithString:event.imageUrl]
               placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

@end
