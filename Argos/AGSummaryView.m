//
//  AGSummaryView.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "AGSummaryView.h"

@implementation AGSummaryView

- (id)initWithOrigin:(CGPoint)origin text:(NSString*)summaryText
{
    float paddingX = 16.0;
    float paddingY = 8.0;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(origin.x, origin.y, bounds.size.width, 400.0);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // Setup title
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingX,
                                                                        paddingY,
                                                                        bounds.size.width - (paddingX*2),
                                                                        20.0)];
        _titleLabel.text = @"SUMMARY";
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        _titleLabel.textColor = [UIColor colorWithRed:0.573 green:0.58 blue:0.592 alpha:1.0];
        [self addSubview:_titleLabel];
        
        // Setup summary text
        _summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingX,
                                                                          _titleLabel.bounds.origin.y + _titleLabel.bounds.size.height + paddingY*2,
                                                                          bounds.size.width - (paddingX*2),
                                                                          200.0)];
        _summaryLabel.text = summaryText;
        _summaryLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
        _summaryLabel.numberOfLines = 0;
        _summaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_summaryLabel sizeToFit];
        [self addSubview:_summaryLabel];
    }
    return self;
}

@end
