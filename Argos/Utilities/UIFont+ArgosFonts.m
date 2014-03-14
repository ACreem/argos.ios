//
//  UIFont+ArgosFonts.m
//  Argos
//
//  Created by Francis Tseng on 2/28/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "UIFont+ArgosFonts.h"

@implementation UIFont (ArgosFonts)

+ (UIFont*)lightFontForSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Graphik-Light" size:size];
}

+ (UIFont*)mediumFontForSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Graphik" size:size];
}

+ (UIFont*)boldFontForSize:(CGFloat)size {
    return [UIFont fontWithName:@"Graphik-SemiBold" size:size];
}

+ (UIFont*)titleFontForSize:(CGFloat)size {
    return [UIFont fontWithName:@"Graphik-LightItalic" size:size];
}

@end
