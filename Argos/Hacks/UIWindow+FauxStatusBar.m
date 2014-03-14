//
//  UIWindow+FauxStatusBar.m
//  Argos
//
//  Created by Francis Tseng on 3/13/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "UIWindow+FauxStatusBar.h"

static int kFauxStatusBarTag = 99; // Keep track of our fake status bar background.

@implementation UIWindow (FauxStatusBar)

+ (void)showFauxStatusBar
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *fauxStatusBar = [window viewWithTag:kFauxStatusBarTag];
    if (!fauxStatusBar) {
        fauxStatusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(window.frame), 20)];
        fauxStatusBar.backgroundColor = [UIColor headerColor];
        fauxStatusBar.tag = kFauxStatusBarTag;
        [window addSubview:fauxStatusBar];
    }
    fauxStatusBar.hidden = NO;
}

+ (void)hideFauxStatusBar
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *fauxStatusBar = [window viewWithTag:kFauxStatusBarTag];
    if (fauxStatusBar) {
        fauxStatusBar.hidden = YES;
    }
}

@end
