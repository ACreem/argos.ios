//
//  BaseEntity+Concepts.h
//  Argos
//
//  Created by Francis Tseng on 3/17/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "BaseEntity.h"

@interface BaseEntity (Concepts)

// Hack to assert that all BaseEntity child entities
// have a `concepts` relationship.
// This is because RestKit has issues with mapping
// relationships to abstract entities,
// see https://github.com/publicscience/argos.ios/issues/66
@property (nonatomic, retain) NSSet *concepts;

@end
