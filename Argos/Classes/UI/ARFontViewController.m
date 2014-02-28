//
//  ARFontViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/19/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARFontViewController.h"

float static const kFontSizeLarge = 1;
float static const kFontSizeMedium = 0.9;
float static const kFontSizeSmall = 0.75;
static NSString* kFontSizeKey = @"fontSize";
static NSString* kFontTypeKey = @"fontType";
static NSString* kContrastKey = @"contrast";
static NSString* kGraphikType = @"Graphik-Regular";
static NSString* kMarionType = @"Marion";
static NSString* kPalatinoType = @"Palatino";

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
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float width = screenRect.size.width;
    float topPadding = 100;
    float xPadding = 12;
    float yPadding = 40;
    float barHeight = 60;
    
    // Remove the UITabBar's top shadow/line.
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    
    // For background transparency.
    // Note: UITabBar's translucent must be set to YES for this to work.
    // It is set to YES by default, but note that you can't set it using UITabBar appearance.
    [[UITabBar appearance] setBarTintColor:[UIColor clearColor]];
    
    // For selection/item colors.
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]]; // Note: seems to be an iOS7 bug where this is taken as the selected image tint color.
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]]; // Note: seems to be an iOS7 bug where this value is ignored.
    
    // Setup type size selection.
    UITabBarItem *largeSize = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"type_large"] tag:0];
    UITabBarItem *mediumSize = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"type_medium"] tag:1];
    UITabBarItem *smallSize = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"type_small"] tag:2];
    
    _typeSizeSelectionBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, topPadding, width, barHeight)];
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
    bottomBorder.frame = CGRectMake(xPadding, barHeight - 1, width - xPadding*2, 1);
    bottomBorder.backgroundColor = [UIColor actionColor].CGColor;
    [_typeSizeSelectionBar.layer addSublayer:bottomBorder];
    
    [self.view addSubview:_typeSizeSelectionBar];
    
    
    // Setup type selection.
    // Since there are no vertical UITabBars, fake it with some vertical buttons.
    UIView *typeSelectionView = [[UIView alloc] initWithFrame:CGRectMake(0, _typeSizeSelectionBar.frame.origin.y + _typeSizeSelectionBar.frame.size.height + yPadding, width, 160)];
    
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
    
    UIButton* marion = [[UIButton alloc] initWithFrame:CGRectMake(0, graphik.frame.origin.y + graphik.frame.size.height + yPadding/2, width, 40)];
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
    
    UIButton* palatino = [[UIButton alloc] initWithFrame:CGRectMake(0, marion.frame.origin.y + marion.frame.size.height + yPadding/2, width, 40)];
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
    UITabBar *contrastSelectionBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, typeSelectionView.frame.origin.y + typeSelectionView.frame.size.height + yPadding, width, barHeight + 20)];
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
    topBorder.backgroundColor = [UIColor actionColor].CGColor;
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
