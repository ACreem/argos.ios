//
//  GalleryImageViewCell.m
//  Argos
//
//  Created by Francis Tseng on 3/2/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "GalleryImageViewCell.h"

@implementation GalleryImageViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       CGRectGetWidth(self.frame),
                                                                       CGRectGetHeight(self.frame))];
        self.imageView.image = [UIImage imageNamed:@"placeholder"];
        [self addSubview:self.imageView];
    }
    return self;
}

@end
