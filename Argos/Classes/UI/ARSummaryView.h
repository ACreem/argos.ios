//
//  ARSummaryView.h
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ARSummaryViewDelegate

- (void)viewEntity:(NSString*)entityId;

@end

@interface ARSummaryView : UIView <UIWebViewDelegate>

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIWebView *summaryWebView;
@property (assign, nonatomic) id delegate;

- (id)initWithOrigin:(CGPoint)origin text:(NSString*)summaryText updatedAt:(NSDate*)updatedAt;
- (void)setText:(NSString*)summaryText withMentions:(NSSet*)mentions;

@end
