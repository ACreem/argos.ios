//
//  CollectionViewTest.m
//  Argos
//
//  Created by Francis Tseng on 3/16/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CollectionView.h"

@interface CollectionViewTest : XCTestCase
@property (nonatomic, strong) CollectionView *collectionView;
@end

@implementation CollectionViewTest

- (void)setUp
{
    [super setUp];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UICollectionViewFlowLayout* collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    [collectionViewLayout setMinimumInteritemSpacing:0.0f];
    [collectionViewLayout setMinimumLineSpacing:0.0f];
    [collectionViewLayout setSectionInset:UIEdgeInsetsZero];
    [collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [collectionViewLayout setHeaderReferenceSize:CGSizeMake(CGRectGetWidth(screenRect), 30)];
    self.collectionView = [[CollectionView alloc] initWithFrame:screenRect collectionViewLayout:collectionViewLayout];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testResizesContentSizeIfScrollNotEnabled
{
    self.collectionView.scrollEnabled = NO;
    
    CGSize contentSize = CGSizeMake(320, 600);
    self.collectionView.contentSize = contentSize;
    XCTAssertNotEqual(CGRectGetHeight(self.collectionView.frame), self.collectionView.contentSize.height, @"Frame height should not equal content size height");
    
    [self.collectionView sizeToFit];
    
    XCTAssertEqual(CGRectGetHeight(self.collectionView.frame), self.collectionView.contentSize.height, @"Frame height should equal content size height after resizing");
}

- (void)testDoesNotResizeContentSizeIfScrollEnabled
{
    self.collectionView.scrollEnabled = YES;
    
    CGSize contentSize = CGSizeMake(320, 600);
    self.collectionView.contentSize = contentSize;
    XCTAssertNotEqual(CGRectGetHeight(self.collectionView.frame), self.collectionView.contentSize.height, @"Frame height should not equal content size height");
    
    [self.collectionView sizeToFit];
    
    XCTAssertNotEqual(CGRectGetHeight(self.collectionView.frame), self.collectionView.contentSize.height, @"Frame height should not content size height after resizing");
}

@end
