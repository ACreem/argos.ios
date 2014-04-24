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
    return [UIColor colorWithRed:0.125 green:0.137 blue:0.176 alpha:1.0];
}

+ (UIColor*)secondaryColor
{
    return [UIColor colorWithRed:0.141 green:0.49 blue:0.875 alpha:1.0];
}

+ (UIColor*)headerColor
{
    return [UIColor colorWithRed:0.878 green:0.878 blue:0.878 alpha:1.0];
}

+ (UIColor*)actionColor
{
    return [UIColor colorWithRed:0.141 green:0.49 blue:0.875 alpha:1.0];
}

+ (UIColor*)mutedColor
{
    return [UIColor colorWithRed:0.573 green:0.58 blue:0.592 alpha:1.0];
}

+ (UIColor*)mutedAltColor
{
    return [UIColor colorWithRed:0.325 green:0.357 blue:0.42 alpha:1.0];
}

+ (UIColor*)darkColor
{
    return [UIColor colorWithRed:0.067 green:0.067 blue:0.067 alpha:1.0];
}

@end
