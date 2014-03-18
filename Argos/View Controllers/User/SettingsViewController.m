//
//  SettingsViewController.m
//  Argos
//
//  Created by Francis Tseng on 3/17/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.078 green:0.086 blue:0.114 alpha:1.0];
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGFloat padding = 12;
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, screenRect.size.height/2 - 36 - padding, screenRect.size.width - 2*padding, 36)];
    noteLabel.text = @"No settings yet!";
    noteLabel.font = [UIFont titleFontForSize:14.0];
    noteLabel.textAlignment = NSTextAlignmentCenter;
    noteLabel.backgroundColor = [UIColor actionColor];
    noteLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:noteLabel];
}

@end
