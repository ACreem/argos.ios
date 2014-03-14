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

@class BaseEntity;

@protocol ARSummaryViewDelegate <NSObject>
- (void)viewConcept:(NSString*)conceptId;
@end

@interface ARSummaryView : UIView <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *summaryWebView;
@property (nonatomic, strong) BaseEntity *entity;
@property (nonatomic, weak) id <ARSummaryViewDelegate> delegate;

- (instancetype)initWithOrigin:(CGPoint)origin;
- (void)setText:(NSString*)summaryText withMentions:(NSSet*)mentions;

@end
