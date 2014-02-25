//
//  ARTableView.m
//  Argos
//
//  Created by Francis Tseng on 2/23/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARTableView.h"
#import "ARTableViewCell.h"

@implementation ARTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerClass: [ARTableViewCell class] forCellReuseIdentifier: @"Cell"];  // TO DO: THIS NEEDS TO BE MORE FLEXIBLE TO OTHER TABLEVIEWCELL TYPES.
        
        // Set cell separator to full width, if necessary.
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    return self;
}

# pragma mark - UIView
- (void)sizeToFit {
    // Sizes the view to fit all of its content
    // if scroll is disabled,
    // assuming that this view is part of another UIScrollView
    // which handles scrolling.
    if (!self.scrollEnabled) {
        CGRect tableViewFrame = self.frame;
        tableViewFrame.size.height = self.contentSize.height;
        self.frame = tableViewFrame;
    }
}

@end
