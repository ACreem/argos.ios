//
//  ARFontViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/19/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARFontViewController.h"
#import "CurrentUser.h"

float const kFontSizeLarge = 1.1;
float const kFontSizeMedium = 0.9;
float const kFontSizeSmall = 0.7;

@interface ARFontViewController () {
    UITabBar *_typeSizeSelectionBar;
    UIButton *_selectedTypeButton;
    CurrentUser *_currentUser;
}
@end

@implementation ARFontViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _currentUser = [[ARObjectManager sharedManager] currentUser];
    
    float width = 200;
    float topPadding = 10;
    float xPadding = 12;
    self.view.backgroundColor = [UIColor primaryColor];
    
    // Remove the UITabBar's top shadow/line.
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    
    // Setup type size selection.
    UITabBarItem *largeSize = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"type_large"] tag:0];
    UITabBarItem *mediumSize = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"type_medium"] tag:1];
    UITabBarItem *smallSize = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"type_small"] tag:2];
    
    _typeSizeSelectionBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, topPadding, width, 44)];
    _typeSizeSelectionBar.barTintColor = [UIColor primaryColor];
    _typeSizeSelectionBar.translucent = NO;
    _typeSizeSelectionBar.tintColor = [UIColor whiteColor]; // Note: seems to be an iOS7 bug where this is taken as the selected image tint color.
    _typeSizeSelectionBar.selectedImageTintColor = [UIColor whiteColor]; // Note: seems to be an iOS7 bug where this value is ignored.
    [_typeSizeSelectionBar setItems:[NSArray arrayWithObjects:smallSize, mediumSize, largeSize, nil]];
    _typeSizeSelectionBar.delegate = self;
    
    if ([_currentUser.fontSize floatValue] == kFontSizeLarge) {
        _typeSizeSelectionBar.selectedItem = largeSize;
    } else if ([_currentUser.fontSize floatValue] == kFontSizeMedium) {
        _typeSizeSelectionBar.selectedItem = mediumSize;
    } else {
        _typeSizeSelectionBar.selectedItem = smallSize;
    }
    
    // Bottom border for the UITabBar.
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(xPadding, 43, width - xPadding*2, 1);
    bottomBorder.backgroundColor = [UIColor mutedAltColor].CGColor;
    [_typeSizeSelectionBar.layer addSublayer:bottomBorder];
    
    [self.view addSubview:_typeSizeSelectionBar];
    
    
    // Setup type selection.
    // Since there are no vertical UITabBars, fake it with some vertical buttons.
    UIView *typeSelectionView = [[UIView alloc] initWithFrame:CGRectMake(0, _typeSizeSelectionBar.frame.origin.y + _typeSizeSelectionBar.frame.size.height, width, 120)];
    
    UIButton* georgia = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    georgia.tag = 0;
    [georgia addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventTouchUpInside];
    [georgia setTitle:@"Georgia" forState:UIControlStateNormal];
    georgia.titleLabel.font = [UIFont fontWithName:@"Georgia" size:16.0];
    georgia.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    georgia.contentEdgeInsets = UIEdgeInsetsMake(0, xPadding, 0, 0);
    if ([_currentUser.fontType isEqualToString:@"Georgia"]) {
        [georgia setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _selectedTypeButton = georgia;
    } else {
        [georgia setTitleColor:[UIColor mutedAltColor] forState:UIControlStateNormal];
    }
    [typeSelectionView addSubview:georgia];
    
    UIButton* marion = [[UIButton alloc] initWithFrame:CGRectMake(0, georgia.frame.origin.y + georgia.frame.size.height, width, 40)];
    marion.tag = 1;
    [marion addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventTouchUpInside];
    [marion setTitle:@"Marion" forState:UIControlStateNormal];
    marion.titleLabel.font = [UIFont fontWithName:@"Marion" size:16.0];
    marion.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    marion.contentEdgeInsets = UIEdgeInsetsMake(0, xPadding, 0, 0);
    if ([_currentUser.fontType isEqualToString:@"Marion"]) {
        [marion setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _selectedTypeButton = marion;
    } else {
        [marion setTitleColor:[UIColor mutedAltColor] forState:UIControlStateNormal];
    }
    [typeSelectionView addSubview:marion];
    
    UIButton* palatino = [[UIButton alloc] initWithFrame:CGRectMake(0, marion.frame.origin.y + marion.frame.size.height, width, 40)];
    palatino.tag = 2;
    [palatino addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventTouchUpInside];
    [palatino setTitle:@"Palatino" forState:UIControlStateNormal];
    palatino.titleLabel.font = [UIFont fontWithName:@"Palatino" size:16.0];
    palatino.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    palatino.contentEdgeInsets = UIEdgeInsetsMake(0, xPadding, 0, 0);
    if ([_currentUser.fontType isEqualToString:@"Palatino"]) {
        [palatino setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _selectedTypeButton = palatino;
    } else {
        [palatino setTitleColor:[UIColor mutedAltColor] forState:UIControlStateNormal];
    }
    [typeSelectionView addSubview:palatino];
    
    [self.view addSubview:typeSelectionView];
    
    
    // Setup contrast selection.
    UITabBarItem *light = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"light"] tag:0];
    UITabBarItem *dark = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"dark"] tag:1];
    UITabBar *contrastSelectionBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, typeSelectionView.frame.origin.y + typeSelectionView.frame.size.height, width, 60)];
    contrastSelectionBar.barTintColor = [UIColor primaryColor];
    contrastSelectionBar.translucent = NO;
    contrastSelectionBar.tintColor = [UIColor whiteColor]; // Note: seems to be an iOS7 bug where this is taken as the selected image tint color.
    contrastSelectionBar.selectedImageTintColor = [UIColor whiteColor]; // Note: seems to be an iOS7 bug where this value is ignored.
    [contrastSelectionBar setItems:[NSArray arrayWithObjects:light, dark, nil]];
    contrastSelectionBar.delegate = self;
    if ([_currentUser.contrast boolValue]) {
        contrastSelectionBar.selectedItem = light;
    } else {
        contrastSelectionBar.selectedItem = dark;
    }
    
    // Top border for the UITabBar.
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(xPadding, 0, width - xPadding*2, 1);
    topBorder.backgroundColor = [UIColor mutedAltColor].CGColor;
    [contrastSelectionBar.layer addSublayer:topBorder];
    
    [self.view addSubview:contrastSelectionBar];
    
    CGRect frame = self.view.frame;
    frame.size.height = typeSelectionView.frame.size.height + contrastSelectionBar.frame.size.height + _typeSizeSelectionBar.frame.size.height + topPadding/2;
    frame.size.width = width;
    self.view.frame = frame;
}

# pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (tabBar == _typeSizeSelectionBar) {
        switch (item.tag) {
            case 0:
            {
                _currentUser.fontSize = [NSNumber numberWithFloat:kFontSizeLarge];
                break;
            }
            case 1:
            {
                _currentUser.fontSize = [NSNumber numberWithFloat:kFontSizeMedium];
                break;
            }
            case 2:
            {
                _currentUser.fontSize = [NSNumber numberWithFloat:kFontSizeSmall];
                break;
            }
        }
    } else {
        switch (item.tag) {
            case 0:
            {
                _currentUser.contrast = [NSNumber numberWithBool:YES];
                break;
            }
            case 1:
            {
                _currentUser.contrast = [NSNumber numberWithBool:NO];
                break;
            }
        }
    }
}

- (void)selectFont:(id)sender
{
    UIButton* button = (UIButton*)sender;
    switch (button.tag) {
        case 0:
        {
            _currentUser.fontType = @"Georgia";
            break;
        }
        case 1:
        {
            _currentUser.fontType = @"Marion";
            break;
        }
        case 2:
        {
            _currentUser.fontType = @"Palatino";
            break;
        }
    }
    [_selectedTypeButton setTitleColor:[UIColor mutedAltColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _selectedTypeButton = button;
}

@end
