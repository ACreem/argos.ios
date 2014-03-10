//
//  SearchViewController.m
//  Argos
//
//  Created by Francis Tseng on 3/9/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultsViewController.h"

#import "AppDelegate.h"

@interface SearchViewController ()
@property (strong, nonatomic) UILabel *loadingLabel;
@end

@implementation SearchViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialize view controllers.
        SearchResultsViewController *storyResultsViewController = [[SearchResultsViewController alloc] initForEntityNamed:@"Story"];
        storyResultsViewController.title = @"Stories";
        
        SearchResultsViewController *eventResultsViewController = [[SearchResultsViewController alloc] initForEntityNamed:@"Event"];
        eventResultsViewController.title = @"Events";
        
        SearchResultsViewController *entityResultsViewController = [[SearchResultsViewController alloc] initForEntityNamed:@"Entity"];
        entityResultsViewController.title = @"Entities";
        
        NSArray *array = [[NSArray alloc] initWithObjects:storyResultsViewController, eventResultsViewController, entityResultsViewController, nil];
        self.viewControllers = array;
        
        self.selectedViewController = storyResultsViewController;
        
        // Configure the tab bar.
        CGRect frame = self.tabBar.frame;
        frame.origin = CGPointMake(0, 0);
        frame.size.height = 32;
        self.tabBar.frame = frame;
        self.tabBar.barTintColor = [UIColor primaryColor];
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont boldFontForSize:12.0], NSFontAttributeName,
                                    [UIColor whiteColor], NSForegroundColorAttributeName, nil];
        
        NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor actionColor], NSForegroundColorAttributeName, nil];
        [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
        
        // Vertically center the text.
        [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0, -10.0)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = NO;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 60, self.navigationController.navigationBar.frame.size.height)];
    _searchBar.barTintColor = [UIColor primaryColor];
    _searchBar.translucent = NO;
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor secondaryColor];
    _searchBar.placeholder = @"Search";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBar];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float padding = 12;
    
    self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, screenRect.size.height + 36, screenRect.size.width - 2*padding, 36)];
    self.loadingLabel.text = @"Looking for results...";
    self.loadingLabel.font = [UIFont titleFontForSize:14.0];
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    self.loadingLabel.backgroundColor = [UIColor actionColor];
    self.loadingLabel.textColor = [UIColor whiteColor];
    self.loadingLabel.alpha = 0.0;
    [self.view addSubview:self.loadingLabel];
    

}

# pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString *query = searchBar.text;
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect frame = self.loadingLabel.frame;
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        frame.origin.y = screenRect.size.height/2 - frame.size.height;
        self.loadingLabel.frame = frame;
        self.loadingLabel.alpha = 1.0;
    }  completion:nil];
    
    // We must make this request with `getObjectsAtPathForRouteNamed` so that the `@metadata` is available for mapping.
    [[ARObjectManager sharedManager] getObjectsAtPathForRouteNamed:@"search" object:@{@"query": query} parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
        
        // Execute fetch request with the new query for each view controller.
        for (SearchResultsViewController* srvc in self.viewControllers) {
            [srvc searchForQuery:query];
        }
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect frame = self.loadingLabel.frame;
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            frame.origin.y = screenRect.size.height + frame.size.height;
            self.loadingLabel.frame = frame;
            self.loadingLabel.alpha = 0.0;
        }  completion:nil];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        NSLog(@"%@", error);
    }];
    
    // Animate and show the tab bar for filtering search results by type.
    if (self.tabBar.frame.origin.y < 0) {
        [UIView animateWithDuration:0.45 delay:0.22 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // Not sure why this is the only way to get the proper navigation bar height.
            // Doing self.navigationController... returns 0.0 for the height.
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            CGRect frame = self.tabBar.frame;
            frame.origin.y += [UIApplication sharedApplication].statusBarFrame.size.height + appDelegate.navigationController.navigationBar.frame.size.height;
            self.tabBar.frame = frame;
        } completion:^(BOOL finished) {
        }];
    }
}

@end
