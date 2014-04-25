//
//  EventDetailView.h
//  Argos
//
//  Created by Francis Tseng on 4/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "Event.h"
#import "DetailView.h"

@interface EventDetailView : DetailView

@property (nonatomic, strong) Event* entity;

- (id)initWithFrame:(CGRect)frame forEvent:(Event*)event;

@end
