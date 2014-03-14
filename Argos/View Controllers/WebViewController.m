//
//  WebViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/18/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) UIWebView* webView;

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
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.webView = [[UIWebView alloc] initWithFrame:bounds];
    self.webView.scalesPageToFit = YES;
    NSURL *targetUrl = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetUrl];
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
}

@end
