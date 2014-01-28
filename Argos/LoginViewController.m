//
//  LoginViewController.m
//  Argos
//
//  Created by Francis Tseng on 1/27/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "LoginViewController.h"
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
	// Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginButtonPressed:(id)sender
{
    NSString* emailValue = [_emailField text];
    NSLog(@"%@", emailValue);
    
    //MasterViewController *masterViewController = [[MasterViewController alloc] init];
    //[self.navigationController pushViewController:masterViewController animated:YES];
    
}

- (void)setupUI
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGFloat buttonWidth = 100;
    CGFloat buttonHeight = 100;
    
    // Create login button
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(screenWidth/2 - buttonWidth/2, screenHeight - buttonHeight*2, buttonWidth, buttonHeight);
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    // Create text fields
    CGFloat fieldWidth = 200;
    CGFloat fieldHeight = 50;
    _emailField = [[UITextField alloc] initWithFrame:CGRectMake(screenWidth/2 - fieldWidth/2, fieldHeight*2, fieldWidth, fieldHeight)];
    _emailField.delegate = self;
    _emailField.placeholder = @"email";
    _emailField.borderStyle = UITextBorderStyleLine;
    _emailField.layer.borderColor = [[UIColor grayColor] CGColor];
    _emailField.layer.borderWidth = 1.0;
    [self.view addSubview:_emailField];
    
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(screenWidth/2 - fieldWidth/2, _emailField.frame.origin.y + (fieldHeight * 2), fieldWidth, fieldHeight)];
    _passwordField.delegate = self;
    _passwordField.secureTextEntry = YES;
    _passwordField.placeholder = @"password";
    _passwordField.borderStyle = UITextBorderStyleLine;
    _passwordField.layer.borderColor = [[UIColor grayColor] CGColor];
    _passwordField.layer.borderWidth = 1.0;
    [self.view addSubview:_passwordField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_emailField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

@end