//
//  ARShareViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/19/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARShareViewController.h"
#import "ARCircleButton.h"

static const CGSize kItemSize = {64, 88};
static const CGSize kIconSize = {64, 64};

@interface ARShareViewController ()
@property (strong, nonatomic) NSArray *items;
@end

@implementation ARShareViewController

- (id)init
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:12];
    [flowLayout setMinimumLineSpacing:34];
    [flowLayout setSectionInset:UIEdgeInsetsMake(100, 32, 32, 32)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [flowLayout setItemSize:kItemSize];
    
    self = [super initWithCollectionViewLayout:flowLayout];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set a transparent background.
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    
    // These values will automatically match up with icons/images with the same name.
    _items = [[NSArray alloc] initWithObjects:@"facebook", @"twitter", @"google", @"mail", @"messaging", @"link", nil];

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

# pragma mark - UICollectionViewDataSource
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ARCircleButton* button = [[ARCircleButton alloc] initWithFrame:CGRectMake(kItemSize.width/2 - kIconSize.width/2, 0, kIconSize.width, kIconSize.height)];
    [button setImage:[UIImage imageNamed:[_items objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    button.tintColor = [UIColor whiteColor];
    button.userInteractionEnabled = NO; // so button touches pass through and are handled by didSelectItemAtIndexPath
    [cell addSubview:button];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kIconSize.height, kItemSize.width, 22)];
    titleLabel.text = [[_items objectAtIndex:indexPath.row] capitalizedString];
    titleLabel.font = [UIFont fontWithName:@"Graphik-Regular" size:12.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:titleLabel];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.items count];
}

# pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* sharingServiceName = [_items objectAtIndex:indexPath.row];
    NSLog(@"sharing to %@", sharingServiceName);
}

@end
