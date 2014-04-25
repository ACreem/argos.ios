//
//  SearchResultsViewController.h
//  Argos
//
//  Created by Francis Tseng on 3/9/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "CollectionViewController.h"

@interface SearchResultsViewController : CollectionViewController

- (id)initForEntityNamed:(NSString*)entityName;
- (void)searchForQuery:(NSString*)query;

@end
