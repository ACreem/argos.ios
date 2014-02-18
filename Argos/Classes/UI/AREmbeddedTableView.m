//
//  AREmbeddedTableView.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "AREmbeddedTableView.h"
#import "Article.h"
#import "Story.h"
#import "Event.h"

@implementation AREmbeddedTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        [self registerClass: [UITableViewCell class] forCellReuseIdentifier: @"Cell"];
        
        // Set cell separator to full width, if necessary.
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        
        _items = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _items.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Should push to web view for the article.
    //[self.navigationController pushViewController:[[EventDetailViewController alloc] init] animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    // Configure the cell...
    id item = [_items objectAtIndex:indexPath.row];
    NSString *title;
    if ([item isKindOfClass:[Story class]]) {
        Story *item_ = (Story*)item;
        title = item_.title;
    } else if ([item isKindOfClass:[Event class]]) {
        Event *item_ = (Event*)item;
        title = item_.title;
    } else {
        Article *item_ = (Article*)item;
        title = item_.title;
    }
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.imageView.image = [UIImage imageNamed:@"sample"];
    
    return cell;
}

- (void)sizeToFit {
    // Auto size the table view.
    CGRect tableViewFrame = self.frame;
    tableViewFrame.size.height = self.contentSize.height;
    self.frame = tableViewFrame;
}

@end
