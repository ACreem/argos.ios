//
//  ARScrollViewSpec.m
//  Argos
//
//  Created by Francis Tseng on 3/2/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "Kiwi.h"
#import "ARScrollView.h"

SPEC_BEGIN(ARScrollViewSpec)

describe(@"ARScrollView", ^{
    __block ARScrollView* scrollView;
    
    beforeEach(^{
        CGRect screenRect = [UIScreen mainScreen].bounds;
        scrollView = [[ARScrollView alloc] initWithFrame:screenRect verticalOffset:0];
    });
    
    afterEach(^{
        scrollView = nil;
    });
    
    it(@"arranges overlapping subviews to fit", ^{
        // Create some overlapping views.
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        
        [scrollView addSubview:view1];
        [scrollView addSubview:view2];
        [scrollView addSubview:view3];
        [[theValue(scrollView.contentSize.height) shouldNot] equal:theValue(view1.frame.size.height + view2.frame.size.height + view3.frame.size.height)];
        
        [scrollView sizeToFit];
        
        [[theValue(scrollView.contentSize.height) should] equal:theValue(view1.frame.size.height + view2.frame.size.height + view3.frame.size.height)];
    });
});

SPEC_END

