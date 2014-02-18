//
//  UIColor+ArgosColors.m
//  Argos
//
//  Created by Francis Tseng on 2/17/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "UIColor+ArgosColors.h"

@implementation UIColor (ArgosColors)

+ (UIColor*)primaryColor
{
    return [UIColor colorWithRed:0.133 green:0.22 blue:0.286 alpha:1.0];
}

+ (UIColor*)secondaryColor
{
    return [UIColor colorWithRed:0.886 green:0.271 blue:0.298 alpha:1.0];
}

+ (UIColor*)actionColor
{
    return [UIColor colorWithRed:0.478 green:0.757 blue:0.471 alpha:1.0];
}

+ (UIColor*)mutedColor
{
    return [UIColor colorWithRed:0.573 green:0.58 blue:0.592 alpha:1.0];
}

@end
