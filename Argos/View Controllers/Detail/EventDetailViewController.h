//
//  EventDetailViewController.h
//  Argos
//
//  Created by Francis Tseng on 2/7/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "DetailViewController.h"
#import "EmbeddedCollectionViewController.h"
#import "Event.h"

@interface EventDetailViewController : DetailViewController <EmbeddedCollectionViewControllerDelegate>

@property (nonatomic, strong) Event *entity;

- (instancetype)initWithEvent:(Event*)event;

@end
