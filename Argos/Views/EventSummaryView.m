//
//  EventSummaryView.m
//  Argos
//
//  Created by Francis Tseng on 4/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EventSummaryView.h"

@implementation EventSummaryView

// Split into sentences and create an HTML list.
- (NSString*)processSummaryText:(NSString*)summaryText {
    /*
    NSMutableArray *chunks = [NSMutableArray arrayWithObject:@"<ul>"];
    [summaryText enumerateSubstringsInRange:NSMakeRange(0, [summaryText length]) options:NSStringEnumerationBySentences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [chunks addObject:[NSString stringWithFormat:@"<li>%@</li>", substring]];
    }];
    [chunks addObject:@"</ul>"];
    return [chunks componentsJoinedByString:@""];
     */
    return summaryText;
}

@end
