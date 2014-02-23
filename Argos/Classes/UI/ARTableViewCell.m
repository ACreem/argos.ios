//
//  ARTableViewCell.m
//  Argos
//
//  Created by Francis Tseng on 2/9/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARTableViewCell.h"

@implementation ARTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContent];
    }
    return self;
}

- (void)setupContent
{
    self.textLabel.font = [UIFont fontWithName:@"KlinicSlab-Book" size:14.0];
    self.textLabel.numberOfLines = 0;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // Create time ago label
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:9.0];
    self.timeLabel.textColor = [UIColor mutedColor];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.timeLabel];
    
    // Create meta label
    self.metaLabel = [[UILabel alloc] init];
    self.metaLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:9.0];
    self.metaLabel.textColor = [UIColor mutedColor];
    self.metaLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.metaLabel];
    
    self.imageView.image = [UIImage imageNamed:@"placeholder"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float paddingX = 10;
    self.imageView.frame = CGRectMake(0, 0, 60, self.frame.size.height);
    self.textLabel.frame = CGRectMake(self.imageView.frame.size.width + paddingX,
                                      0,
                                      self.frame.size.width - self.imageView.frame.size.width - paddingX*2,
                                      40);
    self.timeLabel.frame = CGRectMake(self.textLabel.frame.origin.x,
                                      self.textLabel.frame.size.height - 4,
                                      self.textLabel.frame.size.width,
                                      20);
    self.metaLabel.frame = CGRectMake(self.textLabel.frame.origin.x,
                                      self.textLabel.frame.size.height - 4,
                                      self.textLabel.frame.size.width,
                                      20);
}

@end
