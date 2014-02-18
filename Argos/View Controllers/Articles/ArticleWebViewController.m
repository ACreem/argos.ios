//
//  ArticleWebViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/18/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ArticleWebViewController.h"

@interface ArticleWebViewController () {
    NSString* _url;
    UIWebView* _webView;
}

@end

@implementation ArticleWebViewController

- (ArticleWebViewController*)initWithURL:(NSString*)url
{
    self = [super init];
    if (self) {
        _url = url;
        _url = @"https://www.google.com"; // temporary
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    _webView = [[UIWebView alloc] initWithFrame:bounds];
    _webView.scalesPageToFit = YES;
    NSURL *targetUrl = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetUrl];
    [_webView loadRequest:request];
    
    [self.view addSubview:_webView];
}

@end
