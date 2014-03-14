//
//  ConceptDetailViewController.h
//  Argos
//
//  Created by Francis Tseng on 2/17/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARDetailViewController.h"
#import "Concept.h"

@interface ConceptDetailViewController : ARDetailViewController <AREmbeddedCollectionViewControllerDelegate>

- (ConceptDetailViewController*)initWithConcept:(Concept*)concept;

@end
