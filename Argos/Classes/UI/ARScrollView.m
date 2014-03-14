//
//  ARScrollView.m
//  Argos
//
//  Created by Francis Tseng on 2/17/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARScrollView.h"

@interface ARScrollView ()
@property (nonatomic, assign) CGFloat yOffset;
@end

@implementation ARScrollView

- (instancetype)initWithFrame:(CGRect)frame verticalOffset:(float)yOffset
{
    // Initialize the view with an offset.
    // This is so the scroll view itself can be positioned to take the entire
    // screen, but its content can be vertically shifted, allowing for parallax effects.
    
    self = [super initWithFrame:frame];
    _yOffset = yOffset;
    self.showsVerticalScrollIndicator = NO;
    return self;
}

# pragma mark - UIView

- (void)sizeToFit
{
    // Calculate positions of subviews.
    // Assumes vertical layout of all top-level subviews (i.e. the
    // direct children of this scroll view).
    // NB: Make sure all padding is implemented as part of a view's SIZE,
    // NOT its ORIGIN.
    // E.g. if you have a view you want to have 16pt vertical padding between itself
    // and its preceding view, increase it's height by 16pt rather than positioning
    // its origin 16pt further down. You may need to wrap padded views in subviews (though
    // often this works to the benefit of view organization/encapsulation).
    for (UIView *v in [self subviews]) {
        CGRect frame = v.frame;
        frame.origin.y = self.yOffset;
        v.frame = frame;
        self.yOffset += CGRectGetHeight(frame);
    }
    
    // Directly overriding `sizeToFit` instead of `sizeThatFits:` since
    // we want to set the content size of the view, rather than its frame size.
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    contentRect.size.height += self.yOffset;
    self.contentSize = contentRect.size;
}

@end
