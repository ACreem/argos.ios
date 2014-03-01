//
//  StoryEventsViewController.h
//  Argos
//
//  Created by Francis Tseng on 3/1/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARCollectionViewController.h"
#import "Story.h"

@interface StoryEventsViewController : ARCollectionViewController

- (StoryEventsViewController*)initWithStory:(Story*)story;

@end
