//
//  ARShareViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/19/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARShareViewController.h"

@interface ARShareViewController ()

@end

@implementation ARShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor primaryColor];
    
    UIButton* facebook = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [facebook setImage:[UIImage imageNamed:@"facebook"] forState:UIControlStateNormal];
    facebook.tintColor = [UIColor whiteColor];
    [self.view addSubview:facebook];
    
    UIButton* twitter = [[UIButton alloc] initWithFrame:CGRectMake(0, facebook.frame.origin.y + facebook.frame.size.height, 44, 44)];
    [twitter setImage:[UIImage imageNamed:@"twitter"] forState:UIControlStateNormal];
    twitter.tintColor = [UIColor whiteColor];
    [self.view addSubview:twitter];
    
    UIButton* google = [[UIButton alloc] initWithFrame:CGRectMake(0, twitter.frame.origin.y + twitter.frame.size.height, 44, 44)];
    [google setImage:[UIImage imageNamed:@"google"] forState:UIControlStateNormal];
    google.tintColor = [UIColor whiteColor];
    [self.view addSubview:google];
    
    UIButton* mail = [[UIButton alloc] initWithFrame:CGRectMake(0, google.frame.origin.y + google.frame.size.height, 44, 44)];
    [mail setImage:[UIImage imageNamed:@"mail"] forState:UIControlStateNormal];
    mail.tintColor = [UIColor whiteColor];
    [self.view addSubview:mail];
    
    UIButton* link = [[UIButton alloc] initWithFrame:CGRectMake(0, mail.frame.origin.y + mail.frame.size.height, 44, 44)];
    [link setImage:[UIImage imageNamed:@"link"] forState:UIControlStateNormal];
    link.tintColor = [UIColor whiteColor];
    [self.view addSubview:link];
}

@end
