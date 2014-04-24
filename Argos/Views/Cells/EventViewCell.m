//
//  EventViewCell.m
//  Argos
//
//  Created by Francis Tseng on 4/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EventViewCell.h"
#import "BaseEntity.h"

@interface EventViewCell ()
@property (nonatomic, assign) CGFloat xPadding;
@property (nonatomic, assign) CGFloat yPadding;

@property (nonatomic, strong) UIView *metaView;
@property (nonatomic, strong) UIView *socialView;
@end

@implementation EventViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _xPadding = 10;
        _yPadding = 10;
        
        CGFloat metaViewHeight = 24;
        CGFloat socialViewHeight = 24;
        
        //CGFloat imageHeight = 240;
        CGFloat imageHeight = 0;
        /*
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                   CGRectGetWidth(self.frame),
                                                                   imageHeight)];
        _imageView.image = [UIImage imageNamed:@"placeholder"];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
         */
        
        UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, imageHeight,
                                                                    CGRectGetWidth(self.frame),
                                                                    CGRectGetHeight(self.frame))];
        
        // Meta view
        _metaView = [[UIView alloc] initWithFrame:CGRectMake(_xPadding, _yPadding,
                                                                    CGRectGetWidth(self.frame) - 2*_xPadding,
                                                                    metaViewHeight)];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               CGRectGetWidth(_metaView.frame)/2,
                                                               metaViewHeight)];
        _timeLabel.textColor = [UIColor mutedColor];
        _timeLabel.font = [UIFont mediumFontForSize:8];
        [_metaView addSubview:_timeLabel];
        
        UIButton *bookmarkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIImage *bookmarkImage = [UIImage imageNamed:@"bookmark"];
        [bookmarkButton setImage:bookmarkImage forState:UIControlStateNormal];
        bookmarkButton.frame = CGRectMake(CGRectGetWidth(_metaView.frame) - 16, 0, 16, 16);
        bookmarkButton.tintColor = [UIColor mutedColor];
        [_metaView addSubview:bookmarkButton];
        
        [infoView addSubview:_metaView];
        
        // Title label
        CGFloat titleLabelHeight = CGRectGetHeight(self.frame) - metaViewHeight - socialViewHeight;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_xPadding,
                                                                CGRectGetHeight(_metaView.frame) + 2*_yPadding,
                                                                CGRectGetWidth(self.frame) - 2*_xPadding,
                                                                titleLabelHeight)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont mediumFontForSize:14];
        _titleLabel.numberOfLines = 3;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [infoView addSubview:_titleLabel];
        
        
        // Social view
        _socialView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               CGRectGetHeight(self.frame) - socialViewHeight,
                                                               CGRectGetWidth(self.frame),
                                                               socialViewHeight)];
        _socialView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];

        
        UILabel *discussionNumber = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_socialView.frame) - 2*_xPadding,
                                                                              0, 24, socialViewHeight)];
        discussionNumber.text = @"0";
        discussionNumber.textColor = [UIColor mutedColor];
        discussionNumber.font = [UIFont boldFontForSize:10];
        [_socialView addSubview:discussionNumber];
        
        UIButton *discussionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIImage *discussionImage = [UIImage imageNamed:@"discussion"];
        [discussionButton setImage:discussionImage forState:UIControlStateNormal];
        discussionButton.frame = CGRectMake(CGRectGetMinX(discussionNumber.frame) - 20, 4, 16, 16);
        discussionButton.tintColor = [UIColor secondaryColor];
        [_socialView addSubview:discussionButton];
        
        [infoView addSubview:_socialView];

        
        [self addSubview:infoView];
        
        // Drop shadow
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowRadius = 0;
        self.layer.shadowOpacity = .1;
        CGRect shadowFrame = self.layer.bounds;
        CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
        self.layer.shadowPath = shadowPath;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.timeLabel sizeToFit];
    
    CGRect frame;
    
    frame = self.metaView.frame;
    frame.origin.y = self.yPadding;
    self.metaView.frame = frame;
    CGFloat ref = self.metaView.frame.origin.y;
    
    frame = self.titleLabel.frame;
    frame.origin.y = ref + self.yPadding;
    self.titleLabel.frame = frame;
}

- (void)configureCellForEvent:(Event *)event {
    _titleLabel.text = event.title;
    _timeLabel.text = [event.updatedAt timeAgo];
    
    //[_imageView setImageWithURL:[NSURL URLWithString:event.imageUrl]
               //placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

@end