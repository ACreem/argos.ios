//
//  ARScrollView.m
//  Argos
//
//  Created by Francis Tseng on 2/17/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARScrollView.h"
#import "ARSectionHeaderView.h"

@interface ARScrollView () {
    float _yOffset;
}
@end


@implementation ARScrollView

- (ARScrollView*)initWithFrame:(CGRect)frame verticalOffset:(float)yOffset
{
    // Initialize the view with an offset.
    // This is so the scroll view itself can be positioned to take the entire
    // screen, but its content can be vertically shifted, allowing for parallax effects.
    
    self = [super initWithFrame:frame];
    _yOffset = yOffset;
    return self;
}

# pragma mark - UIView

- (void)sizeToFit
{
    // Directly overriding `sizeToFit` instead of `sizeThatFits:` since
    // we want to set the content size of the view, rather than its frame size.
    
    float h = 0;
    
    for (UIView *v in [self subviews]) {
        float fh = v.frame.origin.y + v.frame.size.height;
        h = MAX(fh, h);
    }
    [self setContentSize:(CGSizeMake(self.frame.size.width, h + _yOffset))];
}

// This is called on scroll and when one if its subviews changes size.
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Calculate positions of subviews.
    // NB: Make sure all padding is implemented as part of a view's SIZE,
    // NOT its ORIGIN.
    // E.g. if you have a view you want to have 16pt vertical padding between itself
    // and its preceding view, increase it's height by 16pt rather than positioning
    // its origin 16pt further down. You may need to wrap padded views in subviews (though
    // often this works to the benefit of view organization/encapsulation).
    // NOTE: this does not call `sizeToFit`, if you need it, call it manually.
    float yOffset = NAN;
    for (UIView *v in [self subviews]) {
        CGRect frame = v.frame;
        float oy = frame.origin.y;
        if (isnan(yOffset)) {
            yOffset = oy;
        }
        frame.origin.y = yOffset;
        yOffset += frame.size.height;
        v.frame = frame;
    }
}

@end
