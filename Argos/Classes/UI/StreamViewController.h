//
//  StreamViewController.h
//  Argos
//
//  Created by Francis Tseng on 3/1/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EventListViewController.h"
#import "EAIntroView.h"

@interface StreamViewController : EventListViewController <EAIntroDelegate>

// Determines whether or not the onboarding view is shown.
@property (assign, nonatomic) BOOL userIsNew;

- (id)initWithStream:(NSString*)stream;

@end
