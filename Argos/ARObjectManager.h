//
//  ARObjectManager.h
//  Argos
//
//  Created by Francis Tseng on 2/12/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "RKObjectManager.h"

@interface ARObjectManager : RKObjectManager

+(ARObjectManager*)objectManagerWithManagedObjectStore:(RKManagedObjectStore*)mos;

@end
