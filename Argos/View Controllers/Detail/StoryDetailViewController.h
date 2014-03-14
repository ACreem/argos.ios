//
//  StoryDetailViewController.h
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "DetailViewController.h"
#import "Story.h"

@interface StoryDetailViewController : DetailViewController <EmbeddedCollectionViewControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) Story *entity;

- (instancetype)initWithStory:(Story*)story;

@end
