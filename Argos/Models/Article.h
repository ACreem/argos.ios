//
//  Article.h
//  Argos
//
//  Created by Francis Tseng on 3/17/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Source;

@interface Article : NSManagedObject

@property (nonatomic, retain) NSNumber * articleId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) id extUrl;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) id imageUrl;
@property (nonatomic, retain) id jsonUrl;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) Source *source;

@end
