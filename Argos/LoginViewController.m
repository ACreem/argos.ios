//
//  LoginViewController.m
//  Argos
//
//  Created by Francis Tseng on 1/27/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "EventListViewController.h"
#import "IIViewDeckController.h"
#import "MenuViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    [self.navigationController setNavigationBarHidden:YES];
    _manager = [AFHTTPRequestOperationManager manager];
    [self setupUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)facebookLoginButtonPressed:(id)sender
{
    // Implement oauth flow
    [self postLogin];
}

- (void)twitterLoginButtonPressed:(id)sender
{
    // Implement oauth flow
    [self postLogin];
}

- (void)googleLoginButtonPressed:(id)sender
{
    // Implement oauth flow
    [self postLogin];
}

- (void)postLogin
{
    EventListViewController *elvc = [[EventListViewController alloc] init];
    
    // Add background for the status bar, so the pull menu transition looks better.
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.backgroundColor = [UIColor colorWithRed:0.133 green:0.22 blue:0.286 alpha:1.0];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:view];
    
    // Create the navigation controller for the rest of the application.
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:elvc];
    navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.133 green:0.22 blue:0.286 alpha:1.0];
    navigationController.navigationBar.translucent = NO;
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [navigationController.navigationBar setTitleTextAttributes:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [UIColor whiteColor], NSForegroundColorAttributeName,
            [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0], NSFontAttributeName,
            nil]];
         
    MenuViewController* menuController = [[MenuViewController alloc] init];
    
    // Create the pull menu controller.
    IIViewDeckController* deckController = [[IIViewDeckController alloc]
                                             initWithCenterViewController:navigationController
                                             leftViewController:menuController
                                             rightViewController:nil];
    
    [self.navigationController pushViewController:deckController animated:YES];
}

- (void)setupUI
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGFloat buttonWidth = 200;
    CGFloat buttonHeight = 50;
    CGFloat buttonMargin = 25;
    
    // Create login buttons
    UIButton *facebookLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    facebookLoginButton.frame = CGRectMake(screenWidth/2 - buttonWidth/2, screenHeight/2 - buttonHeight/2, buttonWidth, buttonHeight);
    [facebookLoginButton setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    [facebookLoginButton setBackgroundColor:[UIColor colorWithRed:0.133 green:0.22 blue:0.286 alpha:1.0]];
    [facebookLoginButton setTintColor:[UIColor whiteColor]];
    [facebookLoginButton addTarget:self action:@selector(facebookLoginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:facebookLoginButton];
    
    UIButton *twitterLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    twitterLoginButton.frame = CGRectMake(screenWidth/2 - buttonWidth/2, facebookLoginButton.frame.origin.y - (buttonMargin + buttonHeight), buttonWidth, buttonHeight);
    [twitterLoginButton setTitle:@"Login with Twitter" forState:UIControlStateNormal];
    [twitterLoginButton setBackgroundColor:[UIColor colorWithRed:0.133 green:0.22 blue:0.286 alpha:1.0]];
    [twitterLoginButton setTintColor:[UIColor whiteColor]];
    [twitterLoginButton addTarget:self action:@selector(twitterLoginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twitterLoginButton];
    
    UIButton *googleLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    googleLoginButton.frame = CGRectMake(screenWidth/2 - buttonWidth/2, facebookLoginButton.frame.origin.y + (buttonMargin + buttonHeight), buttonWidth, buttonHeight);
    [googleLoginButton setTitle:@"Login with Google" forState:UIControlStateNormal];
    [googleLoginButton setBackgroundColor:[UIColor colorWithRed:0.133 green:0.22 blue:0.286 alpha:1.0]];
    [googleLoginButton setTintColor:[UIColor whiteColor]];
    [googleLoginButton addTarget:self action:@selector(googleLoginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:googleLoginButton];
}

@end