//
//  ScrollView.h
//  Argos
//
//  Created by Francis Tseng on 2/17/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//
//  ==========================================================
//  A scroll view which is configured to properly size to fit
//  and can be initialized with a vertical offset (i.e. to
//  allow for a header view outside of the scroll view itself,
//  thus enabling parallax effects).
//  ==========================================================

@interface ScrollView : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame verticalOffset:(CGFloat)yOffset;

@end
