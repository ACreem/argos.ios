//
//  EventListViewController.h
//  Argos
//
//  Created by Francis Tseng on 1/27/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (id)initWithTitle:(NSString*)title endpoint:(NSString*)endpoint;

@end
