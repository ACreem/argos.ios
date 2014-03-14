//
//  MentionsViewController.h
//  Argos
//
//  Created by Francis Tseng on 2/28/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARCollectionViewController.h"

@interface MentionsViewController : ARCollectionViewController

- (MentionsViewController*)initWithEntity:(id<AREntity>)entity withPredicate:(NSPredicate*)predicate;

@end
