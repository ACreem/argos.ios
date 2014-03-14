//
//  ConceptDetailViewController.h
//  Argos
//
//  Created by Francis Tseng on 2/17/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "DetailViewController.h"
#import "Concept.h"

@interface ConceptDetailViewController : DetailViewController <EmbeddedCollectionViewControllerDelegate>

@property (nonatomic, strong) Concept *entity;

- (instancetype)initWithConcept:(Concept*)concept;

@end
