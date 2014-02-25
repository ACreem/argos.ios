//
//  ARTableViewController.h
//  Argos
//
//  Created by Francis Tseng on 2/22/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARTableViewCell.h"
#import "ARTableView.h"

// Expect that Core Data entities processed by this
// view controller respond to these methods.
@protocol Entity
    -(NSString*)imageUrl;
    -(UIImage*)image;
    -(void)setImage:(id)image;
@end

@interface ARTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIScrollViewDelegate>

- (id)initWithEntityNamed:(NSString*)entityName;
- (id)initAsEmbeddedWithEntityNamed:(NSString*)entityName withTitle:(NSString*)title;
- (void)downloadImageForEntity:(id<Entity>)entity forIndexPath:(NSIndexPath*)indexPath;
- (void)handleImageForEntity:(id<Entity>)entity forCell:(ARTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;
- (void)loadImagesForOnscreenRows;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) ARTableView *tableView;
@property (assign, nonatomic) BOOL embedded;

@end


