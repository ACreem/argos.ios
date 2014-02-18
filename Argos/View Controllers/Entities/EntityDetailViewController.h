//
//  EntityDetailViewController.h
//  Argos
//
//  Created by Francis Tseng on 2/17/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARDetailViewController.h"
#import "Entity.h"

@interface EntityDetailViewController : ARDetailViewController

- (EntityDetailViewController*)initWithEntity:(Entity*)entity;

@end
