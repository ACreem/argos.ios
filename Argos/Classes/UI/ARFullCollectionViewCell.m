//
//  ARFullCollectionViewCell.m
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARFullCollectionViewCell.h"
#import "ARCircleButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation ARFullCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        screenRect.size.height -= (44 + 20);
        
        self.imageSize = screenRect.size;
        
        float xPadding = 10;
        float yPadding = 20;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.imageSize.width, self.imageSize.height)];
        self.imageView.image = [UIImage imageNamed:@"placeholder"];
        [self addSubview:self.imageView];
        
        // Text gradient (so the text is readable)
        UIView *textGradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.imageSize.width, self.imageSize.height)];
        CAGradientLayer *textGradient = [CAGradientLayer layer];
        textGradient.frame = textGradientView.bounds;
        textGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
        [textGradientView.layer insertSublayer:textGradient atIndex:0];
        textGradientView.alpha = 0.7;
        [self addSubview:textGradientView];
        
        float textLabelHeight = 120;
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding, screenRect.size.height - textLabelHeight - yPadding, screenRect.size.width - 2*xPadding, textLabelHeight)];
        self.textLabel.numberOfLines = 10;
        self.textLabel.font = [UIFont fontWithName:@"Graphik-Regular" size:14.0];
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.textLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.textLabel];
        
        
        float titleLabelHeight = 40;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding, self.textLabel.frame.origin.y - titleLabelHeight - yPadding, screenRect.size.width - 2*xPadding, titleLabelHeight)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont fontWithName:@"Graphik-LightItalic" size:20.0];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.titleLabel];
        
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding, self.titleLabel.frame.origin.y + titleLabelHeight, screenRect.size.width - 2*xPadding, 20)];
        self.timeLabel.textColor = [UIColor mutedColor];
        self.timeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10.0];
        [self addSubview:self.timeLabel];
        
        // Watching toggle button.
        ARCircleButton* watch = [[ARCircleButton alloc] initWithFrame:CGRectMake(screenRect.size.width - 44 - xPadding, xPadding, 44, 44)];
        watch.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [watch setImage:[UIImage imageNamed:@"watch"] forState:UIControlStateNormal];
        [self addSubview:watch];
    }
    return self;
}


@end
