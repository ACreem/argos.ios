//
//  DetailView.m
//  Argos
//
//  Created by Francis Tseng on 3/14/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "DetailView.h"

@implementation DetailView

- (void)setDelegate:(id <DetailViewProtocol>)delegate
{
    _delegate = delegate;
    self.scrollView.delegate = delegate;
    self.summaryView.delegate = delegate;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    [self.progressView setProgress:progress animated:YES];
}

@end
