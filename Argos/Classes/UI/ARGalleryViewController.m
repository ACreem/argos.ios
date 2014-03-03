//
//  ARGalleryViewController.m
//  Argos
//
//  Created by Francis Tseng on 3/2/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARGalleryViewController.h"
#import "ARImageViewCell.h"

@implementation ARGalleryViewController

- (id)init
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [flowLayout setSectionInset:UIEdgeInsetsZero];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self = [super initWithCollectionViewLayout:flowLayout];
    
    [self.collectionView registerClass:[ARImageViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    // Testing
    self.images = [NSMutableArray arrayWithObjects:@"a", @"b", @"c", nil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

# pragma mark - UICollectionViewDataSource
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ARImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.images.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

@end
