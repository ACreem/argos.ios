//
//  SearchResultsViewController.h
//  Argos
//
//  Created by Francis Tseng on 3/9/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARCollectionViewController.h"

@protocol AREntitySearchResult <AREntity>
-(NSString*)title;
-(NSString*)name;
-(NSDate*)updatedAt;
@end

@interface SearchResultsViewController : ARCollectionViewController

- (id)initForEntityNamed:(NSString*)entityName;
- (void)searchForQuery:(NSString*)query;

@end
