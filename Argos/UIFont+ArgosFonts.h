//
//  UIFont+ArgosFonts.h
//  Argos
//
//  Created by Francis Tseng on 2/28/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (ArgosFonts)

+ (UIFont*)lightFontForSize:(CGFloat)size;
+ (UIFont*)mediumFontForSize:(CGFloat)size;
+ (UIFont*)boldFontForSize:(CGFloat)size;
+ (UIFont*)titleFontForSize:(CGFloat)size;

@end
