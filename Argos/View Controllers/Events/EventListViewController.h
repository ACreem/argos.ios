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

- (id)initWithTitle:(NSString*)title stream:(NSString*)stream;

@end
