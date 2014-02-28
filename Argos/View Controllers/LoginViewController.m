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
#import "MenuViewController.h"
#import <QuartzCore/QuartzCore.h>

static int kLoginTag = 0;
static int kSignUpTag = 1;

@interface LoginViewController () {
    UITextField *_emailField;
    UITextField *_passwordField;
    UIButton    *_primaryButton;
}

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor primaryColor];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setupUI];
}

- (void)postLogin
{
    EventListViewController *elvc = [[EventListViewController alloc] initWithTitle:@"Latest" stream:@"latest"];
    elvc.managedObjectContext = self.managedObjectContext;
    
    // Set whether or not the user is new.
    elvc.userIsNew = (BOOL)_primaryButton.tag;
    
    // Add background for the status bar, so the slide-out menu transition looks better.
    // Check first to see if it already exists.
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (![appDelegate.window viewWithTag:kFauxStatusBarTag]) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [UIColor primaryColor];
        view.tag = kFauxStatusBarTag;
        [appDelegate.window addSubview:view];
    }
    
    // Setup the slide-out menu.
    MenuViewController* menuController = [[MenuViewController alloc] init];
    appDelegate.deckController.leftController = menuController;
    
    [self.navigationController pushViewController:elvc animated:YES];
}

- (void)setupUI
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGFloat buttonWidth = 100;
    CGFloat mainButtonWidth = screenWidth;
    CGFloat buttonHeight = 60;
    CGFloat fieldWidth = screenWidth;
    CGFloat fieldHeight = 50;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.965 green:0.965 blue:0.965 alpha:1.0];
    
    UIView *loginView = [[UIView alloc] initWithFrame:screenRect];
    
    // Use same background image as launch, but with a transparent background.
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launch"]];
    logo.frame = screenRect;
    [loginView addSubview:logo];

    
    // Create buttons
    UIButton *signupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    signupButton.frame = CGRectMake(screenWidth - buttonWidth, screenHeight - buttonHeight, buttonWidth, buttonHeight);
    [signupButton setTitle:@"Sign up" forState:UIControlStateNormal];
    signupButton.tintColor = [UIColor mutedColor];
    signupButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    [signupButton addTarget:self action:@selector(togglePrimaryButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signupButton];
    
    UIButton *forgotButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    forgotButton.frame = CGRectMake(20, screenHeight - buttonHeight, buttonWidth, buttonHeight);
    [forgotButton setTitle:@"Forgot password?" forState:UIControlStateNormal];
    forgotButton.tintColor = [UIColor mutedColor];
    forgotButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    [forgotButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotButton];
    
    
    _primaryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _primaryButton.tag = kLoginTag;
    _primaryButton.frame = CGRectMake(screenWidth/2 - mainButtonWidth/2, signupButton.frame.origin.y - signupButton.frame.size.height, mainButtonWidth, buttonHeight);
    [_primaryButton setTitle:@"Login" forState:UIControlStateNormal];
    _primaryButton.tintColor = [UIColor whiteColor];
    _primaryButton.backgroundColor = [UIColor secondaryColor];
    [_primaryButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:_primaryButton];
    
    // Create text fields
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(screenWidth/2 - fieldWidth/2, _primaryButton.frame.origin.y - fieldHeight, fieldWidth, fieldHeight)];
    [_passwordField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _passwordField.delegate = self;
    _passwordField.secureTextEntry = YES;
    _passwordField.placeholder = @"password";
    _passwordField.textAlignment = NSTextAlignmentCenter;
    [loginView addSubview:_passwordField];
    
    _emailField = [[UITextField alloc] initWithFrame:CGRectMake(screenWidth/2 - fieldWidth/2, _passwordField.frame.origin.y - fieldHeight - 1, fieldWidth, fieldHeight)];
    [_emailField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _emailField.delegate = self;
    _emailField.placeholder = @"email";
    _emailField.textAlignment = NSTextAlignmentCenter;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, fieldHeight-1, screenWidth, 1);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1].CGColor;
    [_emailField.layer addSublayer:bottomBorder];
    [loginView addSubview:_emailField];
    
    [self.view addSubview:loginView];

     [UIView animateWithDuration:0.45 delay:0.22 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect frame = loginView.frame;
        frame.origin.y -= 100;
        loginView.frame = frame;
    } completion:^(BOOL finished) {
    }];

    
    /* No social login for now
    // Create login buttons

    UIButton *facebookLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    facebookLoginButton.frame = CGRectMake(screenWidth/2 - buttonWidth/2, screenHeight/2 - buttonHeight/2, buttonWidth, buttonHeight);
    [facebookLoginButton setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    [facebookLoginButton setBackgroundColor:[UIColor colorWithRed:0.263 green:0.376 blue:0.612 alpha:1.0]];
    [facebookLoginButton setTintColor:[UIColor whiteColor]];
    [[facebookLoginButton layer] setCornerRadius:4.0];
    [facebookLoginButton addTarget:self action:@selector(facebookLoginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:facebookLoginButton];
    
    UIButton *twitterLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    twitterLoginButton.frame = CGRectMake(screenWidth/2 - buttonWidth/2, facebookLoginButton.frame.origin.y - (buttonMargin + buttonHeight), buttonWidth, buttonHeight);
    [twitterLoginButton setTitle:@"Login with Twitter" forState:UIControlStateNormal];
    [twitterLoginButton setBackgroundColor:[UIColor colorWithRed:0 green:0.69 blue:0.929 alpha:1.0]];
    [twitterLoginButton setTintColor:[UIColor whiteColor]];
    [twitterLoginButton addTarget:self action:@selector(twitterLoginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [[twitterLoginButton layer] setCornerRadius:4.0];
    [self.view addSubview:twitterLoginButton];
    
    UIButton *googleLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    googleLoginButton.frame = CGRectMake(screenWidth/2 - buttonWidth/2, facebookLoginButton.frame.origin.y + (buttonMargin + buttonHeight), buttonWidth, buttonHeight);
    [googleLoginButton setTitle:@"Login with Google" forState:UIControlStateNormal];
    [googleLoginButton setBackgroundColor:[UIColor colorWithRed:0.827 green:0.243 blue:0.165 alpha:1.0]];
    [googleLoginButton setTintColor:[UIColor whiteColor]];
    [googleLoginButton addTarget:self action:@selector(googleLoginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [[googleLoginButton layer] setCornerRadius:4.0];
    [self.view addSubview:googleLoginButton];
     */

}

- (void)login:(id)sender
{
   [self postLogin];
    if (_emailField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"What's your email?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else if (_passwordField.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password" message:@"Did you forget your password?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        
         //Workaround to authenticate the user through the app.
         // See: https://github.com/mattupstate/flask-security/issues/30
        UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,0,0)];
        webView.delegate = self;
        [self.view addSubview:webView]; // the web view must be added as a subview in order for it to "load".
        
        if (_primaryButton.tag == kLoginTag) {
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"/login" relativeToURL:[NSURL URLWithString:kArgosAPIBaseURLString]]]];
        } else {
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"/register" relativeToURL:[NSURL URLWithString:kArgosAPIBaseURLString]]]];
        }
        [self primaryButtonStartLoading];
    }
}

// Toggles between "Login" and "Sign up" for the primary button.
- (void)togglePrimaryButton:(id)sender
{
    UIButton* button = (UIButton*)sender;
    if (_primaryButton.tag == kLoginTag) {
        [button setTitle:@"Login" forState:UIControlStateNormal];
        [_primaryButton setTitle:@"Sign up" forState:UIControlStateNormal];
        _primaryButton.backgroundColor = [UIColor actionColor];
        _primaryButton.tag = kSignUpTag;
    } else {
        [button setTitle:@"Sign up" forState:UIControlStateNormal];
        [_primaryButton setTitle:@"Login" forState:UIControlStateNormal];
        _primaryButton.backgroundColor = [UIColor secondaryColor];
        _primaryButton.tag = kLoginTag;
    }
}

- (void)primaryButtonStartLoading {
    if (_primaryButton.tag == kLoginTag) {
        [_primaryButton setTitle:@"Logging in..." forState:UIControlStateNormal];
    } else {
        [_primaryButton setTitle:@"Signing you up..." forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.6 delay:0 options:(UIViewAnimationCurveLinear | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat) animations:^{
        _primaryButton.alpha = 0.7;
    }  completion:nil];
    _primaryButton.enabled = NO;
}
- (void)primaryButtonEndLoading {
    if (_primaryButton.tag == kLoginTag) {
        [_primaryButton setTitle:@"Login" forState:UIControlStateNormal];
    } else {
        [_primaryButton setTitle:@"Sign up" forState:UIControlStateNormal];
    }
    _primaryButton.enabled = YES;
    [_primaryButton.layer removeAllAnimations];
   
    [UIView animateWithDuration:0.6 delay:0 options:(UIViewAnimationCurveLinear | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        _primaryButton.alpha = 1;
    }  completion:nil];
}

# pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *js = nil;
    if (_primaryButton.tag == kLoginTag) {
        js = [NSString stringWithFormat:@" \
                        var xmlHttp = new XMLHttpRequest(), \
                        url = document.location.href, \
                        csrf_token = document.getElementById('csrf_token').value, \
                        params = {\"email\":\"%@\", \"password\":\"%@\", \"csrf_token\": csrf_token}; \
                        xmlHttp.open('POST', url, false); \
                        xmlHttp.setRequestHeader('Content-Type', 'application/json'); \
                        xmlHttp.send(JSON.stringify(params)); \
                        xmlHttp.responseText", _emailField.text, _passwordField.text]; // Note, can't use "return" or even have a ";" at the end, but this returns this value.
    } else {
        js = [NSString stringWithFormat:@" \
                        var xmlHttp = new XMLHttpRequest(), \
                        url = document.location.href, \
                        csrf_token = document.getElementById('csrf_token').value, \
                        params = {\"email\":\"%@\", \"password\":\"%@\", \"password_confirm\":\"%@\", \"csrf_token\": csrf_token}; \
                        xmlHttp.open('POST', url, false); \
                        xmlHttp.setRequestHeader('Content-Type', 'application/json'); \
                        xmlHttp.send(JSON.stringify(params)); \
                        xmlHttp.responseText", _emailField.text, _passwordField.text, _passwordField.text]; // Note, can't use "return" or even have a ";" at the end, but this returns this value.
    }

    NSString *response = [webView stringByEvaluatingJavaScriptFromString:js];
    if ([response rangeOfString:@"Specified user does not exist"].location == NSNotFound && [response rangeOfString:@"Invalid password"].location == NSNotFound) {
        /*
         Successful response looks like:
         {
            "meta": {
                "code": 200
            },
            "response": {
                "user": {
                    "id": "the_user_id",
                    "authentication_token": "the_user_authentication_token"
                }
            }
         }
         */
        /* for checking the server response
        NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        NSLog(@"%@", jsonDict);
        */
        
        // Login the user.
        [[ARObjectManager sharedManager] loginCurrentUserWithEmail:_emailField.text
                                                          password:_passwordField.text
                                                           success:^(CurrentUser *currentUser) {
                                                               [self postLogin];
                                                               
                                                               [self primaryButtonEndLoading];
                                                               
                                                               // Reset the fields.
                                                               _emailField.text = @"";
                                                               _passwordField.text = @"";
                                                           } failure:^(NSError *error) {
                                                               [self primaryButtonEndLoading];
                                                               
                                                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid credentials" message:@"You couldn't be logged in with the info you provided." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                               [alert show];
                                                               
                                                               NSLog(@"%@", error);
                                                           }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid credentials" message:@"You couldn't be logged in with the info you provided." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

# pragma mark - UITextFieldDelegate
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