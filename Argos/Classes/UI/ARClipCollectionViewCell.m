//
//  ARClipCollectionViewCell.m
//  Argos
//
//  Created by Francis Tseng on 2/28/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//



#import "ARClipCollectionViewCell.h"

@implementation ARClipCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float xPadding = 10;
        float yPadding = 20;
        
        float textLabelHeight = 50;
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding, self.cellSize.height - textLabelHeight - yPadding, self.cellSize.width - 2*xPadding, textLabelHeight)];
        self.textLabel.numberOfLines = 4;
        self.textLabel.font = [UIFont fontWithName:@"Graphik-Regular" size:12.0];
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.textLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.textLabel];
        
        // Reposition the title label accordingly.
        CGRect titleFrame = self.titleLabel.frame;
        titleFrame.origin.y = self.textLabel.frame.origin.y - titleFrame.size.height;
        self.titleLabel.frame = titleFrame;
    }
    return self;
}


@end
