//
//  EventTabBarController.m
//  Argos
//
//  Created by Francis Tseng on 4/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "EventTabBarController.h"
#import "EventListViewController.h"

#import "SummaryArticlesViewController.h"

@interface EventTabBarController ()
@property (nonatomic, strong) SummaryArticlesViewController *summaryViewController;
@property (nonatomic, strong) EventListViewController *eventListViewController;
@end

@implementation EventTabBarController

- (instancetype)initWithEvent:(Event*)event
{
    self = [super init];
    if (self) {
        // Initialize view controllers.
        //EventListViewController *siblingEventsViewController = [[EventListViewController alloc] initWithTitle:@"Previous updates in this story"];
        //siblingEventsViewController.managedObjectContext = event.managedObjectContext;
        _summaryViewController = [[SummaryArticlesViewController alloc] initWithEvent:event];
        _summaryViewController.title = @"In Greater Depth";
        
        _eventListViewController = [[EventListViewController alloc] initWithTitle:@"Previous updates in this story"];
        _eventListViewController.title = @"Previously";
        _eventListViewController.managedObjectContext = event.managedObjectContext;
        
        // Increase the insets to compensate for the tab bar.
        UIEdgeInsets insets = [(UICollectionViewFlowLayout*)_eventListViewController.collectionViewLayout sectionInset];
        insets.top = 60;
        [(UICollectionViewFlowLayout*)_eventListViewController.collectionViewLayout setSectionInset:insets];
        
        NSArray *array = [[NSArray alloc] initWithObjects:_summaryViewController, _eventListViewController, nil];
        self.viewControllers = array;
        
        self.selectedViewController = _summaryViewController;
        
        // Configure the tab bar.
        CGRect frame = self.tabBar.frame;
        frame.origin = CGPointMake(0, 0);
        self.tabBar.frame = frame;
        self.tabBar.barTintColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        self.tabBar.tintColor = [UIColor secondaryColor];
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont boldFontForSize:10.0], NSFontAttributeName,
                                    [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0], NSForegroundColorAttributeName, nil];
        
        NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIColor secondaryColor], NSForegroundColorAttributeName, nil];
        [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
        
        // Vertically center the text.
        [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0, -18.0)];
        
        _event = event;
    }
    return self;
}

- (void)setEvent:(Event *)event
{
    _event = event;
    _summaryViewController.event = event;
}

@end
