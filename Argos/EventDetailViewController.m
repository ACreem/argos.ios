//
//  EventDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/7/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EventDetailViewController.h"
#import "SectionHeaderView.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Event";
    
    float textPaddingHorizontal = 16.0;
    float textPaddingVertical = 8.0;
    
    // Header image
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sample"]];
    headerImageView.frame = [[UIScreen mainScreen] bounds];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    headerImageView.frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 220.0);
    [self.view addSubview:headerImageView];
    
    
    // Summary view
    UIView *summaryView = [[UIView alloc] initWithFrame:CGRectMake(bounds.origin.x, headerImageView.bounds.size.height, bounds.size.width, 400.0)];
    
    UILabel *summaryTitle = [[UILabel alloc] initWithFrame:CGRectMake(textPaddingHorizontal, textPaddingVertical, bounds.size.width - (textPaddingHorizontal*2), 20.0)];
    summaryTitle.text = @"SUMMARY";
    summaryTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    summaryTitle.textColor = [UIColor colorWithRed:0.573 green:0.58 blue:0.592 alpha:1.0];
    [summaryView addSubview:summaryTitle];
    
    UILabel *summary = [[UILabel alloc] initWithFrame:CGRectMake(textPaddingHorizontal, summaryTitle.bounds.origin.y + summaryTitle.bounds.size.height + textPaddingVertical*2, bounds.size.width - (textPaddingHorizontal*2), 200.0)];
    summary.text = @"Kerry meets with prince Saud al-Faisal for Syrian peace talks. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.";
    summary.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    summary.numberOfLines = 0;
    summary.lineBreakMode = NSLineBreakByWordWrapping;
    [summary sizeToFit];
    [summaryView addSubview:summary];
    [self.view addSubview:summaryView];
    
    SectionHeaderView *sectionHeader = [[SectionHeaderView alloc] initWithTitle:@"Sourced Articles" withOrigin:CGPointMake(bounds.origin.x, summaryView.bounds.origin.y + summaryView.bounds.size.height)];
    [self.view addSubview:sectionHeader];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
