//
//  EventDetailViewController.h
//  Argos
//
//  Created by Francis Tseng on 2/7/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARDetailViewController.h"
#import "AREmbeddedCollectionViewController.h"
#import "Event.h"

@interface EventDetailViewController : ARDetailViewController <UIScrollViewDelegate, AREmbeddedCollectionViewControllerDelegate>

- (EventDetailViewController*)initWithEvent:(Event*)event;

@end
