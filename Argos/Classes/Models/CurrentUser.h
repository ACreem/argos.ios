//
//  CurrentUser.h
//  Argos
//
//  Created by Francis Tseng on 2/27/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CurrentUser : NSManagedObject

@property (nonatomic, retain) NSNumber * userId;

@end
