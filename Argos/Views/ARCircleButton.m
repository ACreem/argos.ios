//
//  ARCircleButton.m
//  Argos
//
//  Created by Francis Tseng on 2/27/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARCircleButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation ARCircleButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Clip the button to a circle and set its border.
        // Assuming a square button.
        self.layer.cornerRadius = CGRectGetWidth(self.frame)/2;
        self.clipsToBounds = YES;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor actionColor].CGColor;
    }
    return self;
}

@end
