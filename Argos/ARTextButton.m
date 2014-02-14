//
//  ARTextButton.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARTextButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation ARTextButton

+ (ARTextButton*)buttonWithTitle:(NSString*)title
{
    ARTextButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    [button sizeToFit];
    button.frame = CGRectMake(0, 0,
                                   button.frame.size.width + 20,
                                   button.frame.size.height);
    button.tintColor = [UIColor colorWithRed:0.478 green:0.757 blue:0.471 alpha:1.0];
    [[button layer] setBorderWidth:1.0];
    [[button layer] setBorderColor:[UIColor colorWithRed:0.478 green:0.757 blue:0.471 alpha:1.0].CGColor];
    [[button layer] setCornerRadius:4.0];
    return button;
}

@end
