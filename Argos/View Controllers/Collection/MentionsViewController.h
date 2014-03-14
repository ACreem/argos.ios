//
//  MentionsViewController.h
//  Argos
//
//  Created by Francis Tseng on 2/28/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "CollectionViewController.h"

@interface MentionsViewController : CollectionViewController

- (MentionsViewController*)initWithEntity:(BaseEntity*)entity withPredicate:(NSPredicate*)predicate;

@end
