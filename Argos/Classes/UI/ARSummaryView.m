//
//  ARSummaryView.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARSummaryView.h"

@implementation ARSummaryView

- (id)initWithOrigin:(CGPoint)origin text:(NSString*)summaryText updatedAt:(NSDate*)updatedAt
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
        _titleLabel.textColor = [UIColor mutedColor];
        [self addSubview:_titleLabel];
        
        // Setup time ago
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingX,
                                                               paddingY,
                                                               bounds.size.width - (paddingX*2),
                                                               20.0)];
        _timeLabel.text = [NSDate dateDiff:updatedAt];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        _timeLabel.textColor = [UIColor mutedColor];
        [self addSubview:_timeLabel];
        
        // Setup summary text
        _summaryTextView = [[UITextView alloc] initWithFrame:CGRectMake(paddingX,
                                                                  _titleLabel.frame.origin.y + _titleLabel.frame.size.height + paddingY*2,
                                                                   bounds.size.width - (paddingX*2),
                                                                   200.0)];
        _summaryTextView.text = summaryText;
        _summaryTextView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
        _summaryTextView.scrollEnabled = NO;
        _summaryTextView.editable = NO;
        [_summaryTextView sizeToFit];
        [self addSubview:_summaryTextView];
        
        [self sizeToFit];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    //float w = 0;
    float h = 0;
    float padding = 24.0;
    
    for (UIView *v in [self subviews]) {
        //float fw = v.frame.origin.x + v.frame.size.width;
        float fh = v.frame.origin.y + v.frame.size.height;
        //w = MAX(fw, w);
        h = MAX(fh, h);
    }
    return CGSizeMake(self.frame.size.width, h + padding);
}


@end
