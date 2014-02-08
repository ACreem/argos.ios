//
//  AGSectionHeaderView.m
//  Argos
//
//  Created by Francis Tseng on 2/7/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "AGSectionHeaderView.h"

@implementation AGSectionHeaderView

- (id)initWithTitle:(NSString*)title withOrigin:(CGPoint)origin
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(origin.x, origin.y, bounds.size.width, 40.0);
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor colorWithRed:0.333 green:0.412 blue:0.525 alpha:1.0];
        self.backgroundColor = [UIColor colorWithRed:0.133 green:0.22 blue:0.286 alpha:1.0];
        UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 0, self.bounds.size.width - 24.0, self.bounds.size.height)];
        sectionTitle.text = @"Sourced Articles";
        sectionTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
        sectionTitle.textColor = [UIColor whiteColor];
        [self addSubview:sectionTitle];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
