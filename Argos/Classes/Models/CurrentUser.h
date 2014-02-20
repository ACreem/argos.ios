//
//  CurrentUser.h
//  Argos
//
//  Created by Francis Tseng on 2/20/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CurrentUser : NSManagedObject

@property (nonatomic, retain) NSNumber * fontSize;
@property (nonatomic, retain) NSString * fontType;
@property (nonatomic, retain) NSNumber * contrast;

@end
