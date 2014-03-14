//
//  CollectionView.m
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "CollectionView.h"

@implementation CollectionView

- (void)sizeToFit {
    // Sizes the view to fit all of its content
    // if scroll is disabled,
    // assuming that this view is part of another UIScrollView
    // which handles scrolling.
    if (!self.scrollEnabled) {
        CGRect viewFrame = self.frame;
        viewFrame.size.height = self.contentSize.height;
        self.frame = viewFrame;
    }
}

@end
