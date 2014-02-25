//
//  AREmbeddedCollectionViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "AREmbeddedCollectionViewController.h"
#import "ARCollectionHeaderView.h"

#import <objc/message.h>

@implementation AREmbeddedCollectionViewController

- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout*)collectionViewLayout forEntityNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [collectionViewLayout setMinimumInteritemSpacing:0.0f];
    [collectionViewLayout setMinimumLineSpacing:0.0f];
    [collectionViewLayout setSectionInset:UIEdgeInsetsZero];
    [collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [collectionViewLayout setHeaderReferenceSize:CGSizeMake(screenRect.size.width, 30)];
    
    self = [super initWithCollectionViewLayout:collectionViewLayout forEntityNamed:entityName withPredicate:predicate];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.scrollEnabled = NO;
    
    [self.collectionView registerClass:[ARCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARCollectionViewCell *cell = (ARCollectionViewCell*)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    return objc_msgSend(self.delegate, @selector(configureCell:atIndexPath:forEmbeddedCollectionViewController:), cell, indexPath, self);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    ARCollectionHeaderView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        _headerView.titleLabel.text = self.title;
        self.collectionView.headerView = _headerView;
        
        reusableview = _headerView;
    }
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate performSelector:@selector(collectionView:didSelectItemAtIndexPath:) withObject:collectionView withObject:indexPath];
}

@end
