//
//  ScrollViewTest.m
//  Argos
//
//  Created by Francis Tseng on 3/16/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ScrollView.h"

@interface ScrollViewTest : XCTestCase
@property (nonatomic, strong) ScrollView *scrollView;
@end

@implementation ScrollViewTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testArrangesOverlappingSubviewsToFit
{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    self.scrollView = [[ScrollView alloc] initWithFrame:screenRect verticalOffset:0];
    
    // Create some overlapping views.
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    CGFloat totalHeight = CGRectGetHeight(view1.frame) + CGRectGetHeight(view2.frame) + CGRectGetHeight(view3.frame);
    
    [self.scrollView addSubview:view1];
    [self.scrollView addSubview:view2];
    [self.scrollView addSubview:view3];
    
    XCTAssertNotEqual(self.scrollView.contentSize.height, totalHeight, @"Content height should not equal total subview height");
    
    [self.scrollView sizeToFit];
    
    XCTAssertEqual(self.scrollView.contentSize.height, totalHeight, @"Content height should equal total subview height");
    
    // Check that the views are positioned properly.
    XCTAssertTrue(CGRectGetMinY(view1.frame) == 0);
    XCTAssertTrue(CGRectGetMinY(view2.frame) == 100);
    XCTAssertTrue(CGRectGetMinY(view3.frame) == 300);
}

- (void)testArrangesOverlappingSubviewsToFitWithVerticalOffset
{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    self.scrollView = [[ScrollView alloc] initWithFrame:screenRect verticalOffset:100];
    
    // Create some overlapping views.
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    
    [self.scrollView addSubview:view1];
    [self.scrollView addSubview:view2];
    [self.scrollView addSubview:view3];
    
    [self.scrollView sizeToFit];
    
    // Check that the views are positioned properly.
    XCTAssertTrue(CGRectGetMinY(view1.frame) == 100);
    XCTAssertTrue(CGRectGetMinY(view2.frame) == 200);
    XCTAssertTrue(CGRectGetMinY(view3.frame) == 400);
}



@end
