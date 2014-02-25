//
//  ARFontViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/19/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARFontViewController.h"
#import "CurrentUser.h"

float const kFontSizeLarge = 1;
float const kFontSizeMedium = 0.9;
float const kFontSizeSmall = 0.75;
NSString* const kFontSizeKey = @"fontSize";
NSString* const kFontTypeKey = @"fontType";
NSString* const kContrastKey = @"contrast";
NSString* const kGraphikType = @"Graphik-Regular";
NSString* const kMarionType = @"Marion";
NSString* const kPalatinoType = @"Palatino";

@interface ARFontViewController () {
    UITabBar *_typeSizeSelectionBar;
    UIButton *_selectedTypeButton;
}
@end

@implementation ARFontViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
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
    
    float fontSize = [prefs floatForKey:kFontSizeKey];
    if (fontSize == kFontSizeLarge) {
        _typeSizeSelectionBar.selectedItem = largeSize;
    } else if (fontSize == kFontSizeMedium) {
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
    
    NSString* fontType = [prefs stringForKey:kFontTypeKey];
    
    UIButton* graphik = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    graphik.tag = 0;
    [graphik addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventTouchUpInside];
    [graphik setTitle:kGraphikType forState:UIControlStateNormal];
    graphik.titleLabel.font = [UIFont fontWithName:kGraphikType size:16.0];
    graphik.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    graphik.contentEdgeInsets = UIEdgeInsetsMake(0, xPadding, 0, 0);
    if ([fontType isEqualToString:kGraphikType]) {
        [graphik setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _selectedTypeButton = graphik;
    } else {
        [graphik setTitleColor:[UIColor mutedAltColor] forState:UIControlStateNormal];
    }
    [typeSelectionView addSubview:graphik];
    
    UIButton* marion = [[UIButton alloc] initWithFrame:CGRectMake(0, graphik.frame.origin.y + graphik.frame.size.height, width, 40)];
    marion.tag = 1;
    [marion addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventTouchUpInside];
    [marion setTitle:kMarionType forState:UIControlStateNormal];
    marion.titleLabel.font = [UIFont fontWithName:kMarionType size:16.0];
    marion.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    marion.contentEdgeInsets = UIEdgeInsetsMake(0, xPadding, 0, 0);
    if ([fontType isEqualToString:kMarionType]) {
        [marion setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _selectedTypeButton = marion;
    } else {
        [marion setTitleColor:[UIColor mutedAltColor] forState:UIControlStateNormal];
    }
    [typeSelectionView addSubview:marion];
    
    UIButton* palatino = [[UIButton alloc] initWithFrame:CGRectMake(0, marion.frame.origin.y + marion.frame.size.height, width, 40)];
    palatino.tag = 2;
    [palatino addTarget:self action:@selector(selectFont:) forControlEvents:UIControlEventTouchUpInside];
    [palatino setTitle:kPalatinoType forState:UIControlStateNormal];
    palatino.titleLabel.font = [UIFont fontWithName:kPalatinoType size:16.0];
    palatino.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    palatino.contentEdgeInsets = UIEdgeInsetsMake(0, xPadding, 0, 0);
    if ([fontType isEqualToString:kPalatinoType]) {
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
    if ([prefs boolForKey:kContrastKey]) {
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
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (tabBar == _typeSizeSelectionBar) {
        switch (item.tag) {
            case 0:
            {
                [prefs setFloat:kFontSizeLarge forKey:kFontSizeKey];
                break;
            }
            case 1:
            {
                [prefs setFloat:kFontSizeMedium forKey:kFontSizeKey];
                break;
            }
            case 2:
            {
                [prefs setFloat:kFontSizeSmall forKey:kFontSizeKey];
                break;
            }
        }
    } else {
        switch (item.tag) {
            case 0:
            {
                [prefs setBool:YES forKey:kContrastKey];
                break;
            }
            case 1:
            {
                [prefs setBool:NO forKey:kContrastKey];
                break;
            }
        }
    }
}

- (void)selectFont:(id)sender
{
    UIButton* button = (UIButton*)sender;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    switch (button.tag) {
        case 0:
        {
            [prefs setObject:kGraphikType forKey:kFontTypeKey];
            break;
        }
        case 1:
        {
            [prefs setObject:kMarionType forKey:kFontTypeKey];
            break;
        }
        case 2:
        {
            [prefs setObject:kPalatinoType forKey:kFontTypeKey];
            break;
        }
    }
    [_selectedTypeButton setTitleColor:[UIColor mutedAltColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _selectedTypeButton = button;
}

@end
