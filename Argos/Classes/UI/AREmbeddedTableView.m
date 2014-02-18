//
//  AREmbeddedTableView.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "AREmbeddedTableView.h"

@implementation AREmbeddedTableView

- (id)initWithFrame:(CGRect)frame title:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _title = title;
        
        self.scrollEnabled = NO;
        [self registerClass: [UITableViewCell class] forCellReuseIdentifier: @"Cell"];
        
        // Set cell separator to full width, if necessary.
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    return self;
}

# pragma mark - UIView
- (void)sizeToFit {
    // Auto size the table view.
    CGRect tableViewFrame = self.frame;
    tableViewFrame.size.height = self.contentSize.height;
    self.frame = tableViewFrame;
}

@end
