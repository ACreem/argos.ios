//
//  AGSummaryView.h
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGSummaryView : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *summaryLabel;

- (id)initWithOrigin:(CGPoint)origin text:(NSString*)summaryText;

@end
