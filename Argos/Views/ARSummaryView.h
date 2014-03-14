//
//  ARSummaryView.h
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//
//  ==========================================================
//  The summary view which is configured to resize to fit its
//  content and includes a UIWebView which properly sets links
//  for mentions included in a summary.
//  ==========================================================

@protocol ARSummaryViewDelegate
- (void)viewEntity:(NSString*)entityId;
@end

@interface ARSummaryView : UIView <UIWebViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIWebView *summaryWebView;
@property (nonatomic, weak) id delegate;

- (instancetype)initWithOrigin:(CGPoint)origin text:(NSString*)summaryText updatedAt:(NSDate*)updatedAt;
- (void)setText:(NSString*)summaryText withMentions:(NSSet*)mentions;

@end
