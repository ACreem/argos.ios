//
//  EmbeddedCollectionViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EmbeddedCollectionViewController.h"

#import <objc/message.h>

@implementation EmbeddedCollectionViewController

- (instancetype)initWithCollectionViewLayout:(UICollectionViewFlowLayout*)collectionViewLayout forEntityNamed:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [collectionViewLayout setMinimumInteritemSpacing:0.0f];
    [collectionViewLayout setMinimumLineSpacing:0.0f];
    [collectionViewLayout setSectionInset:UIEdgeInsetsZero];
    [collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [collectionViewLayout setHeaderReferenceSize:CGSizeMake(screenRect.size.width, 30)];
    
    self = [super initWithCollectionViewLayout:collectionViewLayout
                                forEntityNamed:entityName
                                 withPredicate:predicate];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.scrollEnabled = YES;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell*)[super collectionView:collectionView
                                                       cellForItemAtIndexPath:indexPath];
    
    return objc_msgSend(self.delegate,
                        @selector(configureCell:atIndexPath:forEmbeddedCollectionViewController:),
                        cell, indexPath, self);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate performSelector:@selector(collectionView:didSelectItemAtIndexPath:)
                        withObject:collectionView
                        withObject:indexPath];
}

@end
