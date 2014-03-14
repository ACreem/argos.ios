//
//  Source.h
//  Argos
//
//  Created by Francis Tseng on 3/14/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Article;

@interface Source : NSManagedObject

@property (nonatomic, retain) id extUrl;
@property (nonatomic, retain) id jsonUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sourceId;
@property (nonatomic, retain) NSSet *articles;
@end

@interface Source (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(Article *)value;
- (void)removeArticlesObject:(Article *)value;
- (void)addArticles:(NSSet *)values;
- (void)removeArticles:(NSSet *)values;

@end
