//
//  EventTabBarController.h
//  Argos
//
//  Created by Francis Tseng on 4/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "Event.h"

#import "DetailView.h"

@interface EventTabBarController : UITabBarController

@property (nonatomic, weak) id <DetailViewProtocol> detailDelegate;
@property (nonatomic, strong) Event *event;

- (instancetype)initWithEvent:(Event*)event;

@end
