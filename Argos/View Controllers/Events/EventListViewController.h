//
//  EventListViewController.h
//  Argos
//
//  Created by Francis Tseng on 1/27/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARCollectionViewController.h"
#import "EAIntroView.h"

@interface EventListViewController : ARCollectionViewController <EAIntroDelegate>

// Determines whether or not the onboarding view is shown.
@property (assign, nonatomic) BOOL userIsNew;

- (id)initWithTitle:(NSString*)title stream:(NSString*)stream;

@end
