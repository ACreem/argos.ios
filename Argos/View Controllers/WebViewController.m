//
//  WebViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/18/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "WebViewController.h"

// For modals.
#import "ShareViewController.h"
#import "TransitionDelegate.h"
#import "UIWindow+FauxStatusBar.h"

@interface WebViewController ()
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *forwardButton;
@property (nonatomic, strong) UIBarButtonItem *refreshButton;
@property (nonatomic, strong) TransitionDelegate *transitionController;
@end

@implementation WebViewController

- (instancetype)initWithURL:(NSString*)url
{
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.transitionController = [[TransitionDelegate alloc] init];
    
    self.navigationItem.rightBarButtonItems = [self navigationItems];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.webView = [[UIWebView alloc] initWithFrame:bounds];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    NSURL *targetUrl = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetUrl];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
}

# pragma mark - Setup
- (NSArray*)navigationItems
{
    UIBarButtonItem *paddingItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:nil
                                                                                 action:nil];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                 target:self
                                                                                 action:@selector(share:)];
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_webback"]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(back:)];
    self.backButton.enabled = NO;    // Starts disabled.
    self.forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_webforward"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(forward:)];
    self.forwardButton.enabled = NO; // Starts disabled.
    
    // Starts as a stop.
    self.refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                       target:self
                                                                       action:@selector(stop:)];
    
    return @[ shareButton, paddingItem,
              self.forwardButton, paddingItem,
              self.backButton, paddingItem,
              self.refreshButton, paddingItem ];
}

# pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (webView.canGoBack) {
        self.backButton.enabled = YES;
    } else {
        self.backButton.enabled = NO;
    }
    if (webView.canGoForward) {
        self.forwardButton.enabled = YES;
    } else {
        self.forwardButton.enabled = NO;
    }
    
    self.refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                       target:self
                                                                       action:@selector(stop:)];
    NSMutableArray *navItems = [self.navigationItem.rightBarButtonItems mutableCopy];
    [navItems removeObjectAtIndex:6];
    [navItems insertObject:self.refreshButton atIndex:6];
    self.navigationItem.rightBarButtonItems = navItems;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                       target:self
                                                                       action:@selector(refresh:)];
    NSMutableArray *navItems = [self.navigationItem.rightBarButtonItems mutableCopy];
    [navItems removeObjectAtIndex:6];
    [navItems insertObject:self.refreshButton atIndex:6];
    self.navigationItem.rightBarButtonItems = navItems;
}

# pragma mark - Actions
- (void)back:(id)sender
{
    [self.webView goBack];
}

- (void)forward:(id)sender
{
    [self.webView goForward];
}

- (void)refresh:(id)sender
{
    [self.webView reload];
}

- (void)stop:(id)sender
{
    [self.webView stopLoading];
}

- (void)share:(id)sender
{
    [self presentModalViewController:[[ShareViewController alloc] init]];
}

# pragma mark - UIViewController
// Helper for consistently presenting modal view controllers.
- (void)presentModalViewController:(UIViewController*)viewControllerToPresent
{
    // Set transparent background.
    viewControllerToPresent.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
    
    // Hack to get transparent backgrounds to be respected.
    [viewControllerToPresent setTransitioningDelegate:self.transitionController];
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
    
    // Have to hide our fake status bar at the top, or else it overlays everything.
    [UIWindow hideFauxStatusBar];
    
    // Add the close button.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(screenRect.size.width - 48,
                                                                       [UIApplication sharedApplication].statusBarFrame.size.height,
                                                                       48, 48)];
    [closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeModal:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewControllerToPresent.view addSubview:closeButton];
    
    [super presentViewController:viewControllerToPresent animated:YES completion:nil];
}
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:^{
        // Have to re-show our fake status bar at the top.
        [UIWindow showFauxStatusBar];
    }];
}
- (void)closeModal:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
