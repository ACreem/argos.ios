//
//  ARLargeCollectionViewCell.m
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARLargeCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ARLargeCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        float cellHeight = frame.size.height;
        float xPadding = 10;
        float yPadding = 20;
        
        self.imageSize = CGSizeMake(screenRect.size.width, cellHeight);
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.imageSize.width, self.imageSize.height)];
        self.imageView.image = [UIImage imageNamed:@"placeholder"];
        [self addSubview:self.imageView];
        
        // Text gradient (so the text is readable)
        UIView *textGradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.imageSize.width, self.imageSize.height)];
        CAGradientLayer *textGradient = [CAGradientLayer layer];
        textGradient.frame = textGradientView.bounds;
        textGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
        [textGradientView.layer insertSublayer:textGradient atIndex:0];
        textGradientView.alpha = 0.8;
        [self addSubview:textGradientView];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding, cellHeight - 10 - yPadding, screenRect.size.width - 2*xPadding, 20)];
        self.timeLabel.textColor = [UIColor mutedColor];
        self.timeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10.0];
        [self addSubview:self.timeLabel];
        
        float titleLabelHeight = 40;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding, self.timeLabel.frame.origin.y - titleLabelHeight, screenRect.size.width - 2*xPadding, titleLabelHeight)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont fontWithName:@"Graphik-LightItalic" size:18.0];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.titleLabel];
    }
    return self;
}


@end
