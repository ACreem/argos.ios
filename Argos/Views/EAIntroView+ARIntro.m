//
//  EAIntroView+ARIntro.m
//  Argos
//
//  Created by Francis Tseng on 3/13/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EAIntroView+ARIntro.h"
#import "EAIntroPage.h"

@implementation EAIntroPage (ARIntroPage)

+ (EAIntroView*)introductionWithFrame:(CGRect)frame
{
    EAIntroPage *page1 = [EAIntroPage createPageWithTitle:@"Know more with less"
                                              description:@"Argos helps you stay on top of the news without overwhelming you in content."
                                               imageNamed:@"onboarding00"
                                                    frame:frame];
    EAIntroPage *page2 = [EAIntroPage createPageWithTitle:@"Events"
                                              description:@"Keep up with everything that's happened in a story."
                                               imageNamed:@"onboarding01"
                                                    frame:frame];
    EAIntroPage *page3 = [EAIntroPage createPageWithTitle:@"Concepts"
                                              description:@"Quickly learn the concepts in a story."
                                               imageNamed:@"onboarding02"
                                                    frame:frame];
    EAIntroPage *page4 = [EAIntroPage createPageWithTitle:@"Entities"
                                              description:@"Understand the people, places, and organizations involved."
                                               imageNamed:@"onboarding03"
                                                    frame:frame];
    EAIntroPage *page5 = [EAIntroPage createPageWithTitle:@"Watch"
                                              description:@"Watch the stories that are important to you..."
                                               imageNamed:@"onboarding04"
                                                    frame:frame];
    EAIntroPage *page6 = [EAIntroPage createPageWithTitle:@"Trending"
                                              description:@"...and hear about the stories that are important to everyone else."
                                               imageNamed:@"onboarding05"
                                                    frame:frame];
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:frame andPages:@[ page1, page2, page3, page4, page5, page6 ]];
    return intro;
}


+ (EAIntroPage*)createPageWithTitle:(NSString*)title description:(NSString*)description imageNamed:(NSString*)imageName frame:(CGRect)frame
{
    CGFloat padding = 50;
    UIFont *titleFont = [UIFont fontWithName:@"Graphik-LightItalic" size:24];
    UIView *customView = [[UIView alloc] initWithFrame:frame];
    
    // Setup the title label.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding,
                                                                    CGRectGetHeight(frame)/2 + 60,
                                                                    CGRectGetWidth(frame) - 2*padding,
                                                                    60)];
    titleLabel.font = titleFont;
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // Create a border the same width as the title.
    CALayer *bottomBorder = [CALayer layer];
    CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName: titleFont}].width;
    bottomBorder.frame = CGRectMake(CGRectGetWidth(frame)/2 - width/2 - padding,
                                    CGRectGetHeight(titleLabel.frame) - 20, width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.227 green:0.404 blue:0.984 alpha:1.0].CGColor;
    [titleLabel.layer addSublayer:bottomBorder];
    
    [customView addSubview:titleLabel];
    
    // Setup the description label.
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding,
                                                                   CGRectGetMinY(titleLabel.frame) + CGRectGetHeight(titleLabel.frame),
                                                                   CGRectGetWidth(frame) - 2*padding,
                                                                   60)];
    descLabel.font = [UIFont fontWithName:@"Graphik-Light" size:17];
    descLabel.text = description;
    descLabel.textColor = [UIColor whiteColor];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descLabel.numberOfLines = 0;
    [customView addSubview:descLabel];
    
    EAIntroPage *page = [EAIntroPage pageWithCustomView:customView];
    page.bgImage = [UIImage imageNamed:imageName];
    return page;
}

@end
