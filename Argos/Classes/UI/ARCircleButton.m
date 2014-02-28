//
//  ARCircleButton.m
//  Argos
//
//  Created by Francis Tseng on 2/27/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARCircleButton.h"

@implementation ARCircleButton

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // For fills.
    //CGContextAddEllipseInRect(ctx, rect);
    //CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor blueColor] CGColor]));
    //CGContextFillPath(dctx);
    
    // For strokes.
    // A different rect is specified so the strokes fit in the actual rect.
    CGContextSetLineWidth(ctx, 1);
    CGContextSetStrokeColor(ctx, CGColorGetComponents([UIColor actionColor].CGColor));
    CGContextStrokeEllipseInRect(ctx, CGRectMake(rect.origin.x+1, rect.origin.y+1, rect.size.width-2, rect.size.height-2));
}

@end
