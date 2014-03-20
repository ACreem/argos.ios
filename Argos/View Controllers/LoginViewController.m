//
//  LoginViewController.m
//  Argos
//
//  Created by Francis Tseng on 1/27/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "LoginViewController.h"
#import "StreamViewController.h"
#import "MenuViewController.h"
#import "UIWindow+FauxStatusBar.h"
#import "CurrentUser+Management.h"

static int kLoginTag = 0;
static int kSignUpTag = 1;

@interface LoginViewController ()
@property (nonatomic, strong) LoginView *view;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor primaryColor];
    [self.navigationController setNavigationBarHidden:YES];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.view = [[LoginView alloc] initWithFrame:screenRect];
    self.view.delegate = self;
    self.view.passwordField.delegate = self;
    self.view.emailField.delegate = self;
    self.view.primaryButton.tag = kLoginTag;

     [UIView animateWithDuration:0.45
                           delay:0.22
                         options:UIViewAnimationOptionCurveEaseOut
                      animations:^{
                          CGRect frame = self.view.formView.frame;
                          frame.origin.y -= 100;
                          self.view.formView.frame = frame;
                      }
                      completion:nil];
}

- (void)postLogin
{
    // Add background for the status bar, so the slide-out menu transition looks better.
    [UIWindow showFauxStatusBar];
    
    // Setup the slide-out menu.
    MenuViewController* menuController = [[MenuViewController alloc] init];
    self.deckController.leftController = menuController;
    
    StreamViewController *svc = [[StreamViewController alloc] initWithStream:kArgosLatestStream];
    svc.managedObjectContext = self.managedObjectContext;
    
    // Set whether or not the user is new.
    svc.isNewUser = (BOOL)self.view.primaryButton.tag;
    
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)login:(id)sender
{
    if (self.view.emailField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email"
                                                        message:@"What's your email?"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else if (self.view.passwordField.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password"
                                                        message:@"Did you forget your password?"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        
        // Workaround to authenticate the user through the app.
        // See: https://github.com/mattupstate/flask-security/issues/30
        UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,0,0)];
        webView.delegate = self;
        
        // The web view must be added as a subview in order for it to "load".
        [self.view addSubview:webView];
        
        NSURL *baseUrl = [NSURL URLWithString:kArgosAPIBaseURLString];
        NSString *endpoint = self.view.primaryButton.tag == kLoginTag ? @"/login" : @"/register";
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:endpoint
                                                                 relativeToURL:baseUrl]]];
        [self primaryButtonStartLoading];
    }
}

// Toggles between "Login" and "Sign up" for the primary button.
- (void)togglePrimaryButton:(id)sender
{
    UIButton* button = (UIButton*)sender;
    if (self.view.primaryButton.tag == kLoginTag) {
        [button setTitle:@"Login" forState:UIControlStateNormal];
        [self.view.primaryButton setTitle:@"Sign up" forState:UIControlStateNormal];
        self.view.primaryButton.backgroundColor = [UIColor actionColor];
        self.view.primaryButton.tag = kSignUpTag;
    } else {
        [button setTitle:@"Sign up" forState:UIControlStateNormal];
        [self.view.primaryButton setTitle:@"Login" forState:UIControlStateNormal];
        self.view.primaryButton.backgroundColor = [UIColor secondaryColor];
        self.view.primaryButton.tag = kLoginTag;
    }
}


// Call when logging in begins.
- (void)primaryButtonStartLoading {
    NSString *loadingText = self.view.primaryButton.tag == kLoginTag ? @"Logging in..." : @"Signing you up...";
    [self.view.primaryButton setTitle:loadingText forState:UIControlStateNormal];
    [UIView animateWithDuration:0.6
                          delay:0
                        options:(UIViewAnimationCurveLinear | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat)
                     animations:^{
                         self.view.primaryButton.alpha = 0.7;
                     }
                     completion:nil];
    self.view.primaryButton.enabled = NO;
}


// Call when logging in ends (or fails).
- (void)primaryButtonEndLoading {
    NSString *titleText = self.view.primaryButton.tag == kLoginTag ? @"Login" : @"Sign up";
    [self.view.primaryButton setTitle:titleText forState:UIControlStateNormal];
    self.view.primaryButton.enabled = YES;
    [self.view.primaryButton.layer removeAllAnimations];
   
    [UIView animateWithDuration:0.6
                          delay:0
                        options:(UIViewAnimationCurveLinear | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         self.view.primaryButton.alpha = 1;
                     }
                     completion:nil];
}


# pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *js = nil;
    if (self.view.primaryButton.tag == kLoginTag) {
        js = [NSString stringWithFormat:@" \
                        var xmlHttp = new XMLHttpRequest(), \
                        url = document.location.href, \
                        csrf_token = document.getElementById('csrf_token').value, \
                        params = {\"email\":\"%@\", \"password\":\"%@\", \"csrf_token\": csrf_token}; \
                        xmlHttp.open('POST', url, false); \
                        xmlHttp.setRequestHeader('Content-Type', 'application/json'); \
                        xmlHttp.send(JSON.stringify(params)); \
                        xmlHttp.responseText", self.view.emailField.text, self.view.passwordField.text];
                        // Note, can't use "return" or even have a ";" at the end, but this returns this value.
    } else {
        js = [NSString stringWithFormat:@" \
                        var xmlHttp = new XMLHttpRequest(), \
                        url = document.location.href, \
                        csrf_token = document.getElementById('csrf_token').value, \
                        params = {\"email\":\"%@\", \"password\":\"%@\", \"password_confirm\":\"%@\", \"csrf_token\": csrf_token}; \
                        xmlHttp.open('POST', url, false); \
                        xmlHttp.setRequestHeader('Content-Type', 'application/json'); \
                        xmlHttp.send(JSON.stringify(params)); \
                        xmlHttp.responseText", self.view.emailField.text, self.view.passwordField.text, self.view.passwordField.text];
                        // Note, can't use "return" or even have a ";" at the end, but this returns this value.
    }

    NSString *response = [webView stringByEvaluatingJavaScriptFromString:js];
    if ([response rangeOfString:@"Specified user does not exist"].location == NSNotFound && [response rangeOfString:@"Invalid password"].location == NSNotFound) {
        /* for checking the server response
        NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        NSLog(@"%@", jsonDict);
        */
        
        // Login the user.
        [CurrentUser loginWithEmail:self.view.emailField.text
                           password:self.view.passwordField.text
                            success:^(CurrentUser *currentUser) {
                                [self postLogin];
                               
                                [self primaryButtonEndLoading];
                               
                                // Reset the fields.
                                self.view.emailField.text = @"";
                                self.view.passwordField.text = @"";
                            } failure:^(NSError *error) {
                                [self primaryButtonEndLoading];
                               
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid credentials"
                                                                                message:@"You couldn't be logged in with the info you provided."
                                                                               delegate:self
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];
                               
                                NSLog(@"%@", error);
                           }];
    } else {
        [self primaryButtonEndLoading];
        NSLog(@"%@", response);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid credentials"
                                                        message:@"You couldn't be logged in with the info you provided."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error: %@", error.localizedDescription);
}

# pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.view.emailField) {
        [self.view.passwordField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return NO;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view.emailField resignFirstResponder];
    [self.view.passwordField resignFirstResponder];
}

@end