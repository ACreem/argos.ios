//
//  ARCollectionHeaderView.m
//  Argos
//
//  Created by Francis Tseng on 2/25/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARCollectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ARCollectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        float padding = 10;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 0, self.frame.size.width - 2*padding, self.frame.size.height)];
        _titleLabel.font = [UIFont lightFontForSize:16];
        _titleLabel.textColor = [UIColor lightGrayColor];
        
        [self addSubview:_titleLabel];
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 1.0f);
        bottomBorder.backgroundColor = [UIColor secondaryColor].CGColor;
        [self.layer addSublayer:bottomBorder];
    }
    return self;
}

@end
