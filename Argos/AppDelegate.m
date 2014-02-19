//
//  AppDelegate.m
//  Argos
//
//  Created by Francis Tseng on 1/27/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "AppDelegate.h"
#import "ARObjectManager.h"
#import "LoginViewController.h"
#import "ReachabilityManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Instiatiate network reachability monitor.
    [ReachabilityManager sharedManager];
    
    // Setup RestKit.
    NSManagedObjectContext* moc = [self setupRestKit];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    LoginViewController *lvc = [[LoginViewController alloc] init];
    lvc.managedObjectContext = moc;
    
    // Setup the navigation controller.
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:lvc];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor primaryColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [UIColor whiteColor], NSForegroundColorAttributeName,
            [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0], NSFontAttributeName,
            nil]];
    
    // Custom back button image.
    [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"nav_back"]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"nav_back"]];
 
    
    // Create the pull menu controller.
    self.deckController = [[IIViewDeckController alloc]
                             initWithCenterViewController:self.navigationController
                             leftViewController:nil
                             rightViewController:nil];
    self.deckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.deckController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // Save core data.
    NSError *executeError = nil;
    NSManagedObjectContext *managedObjCtx = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    if(![managedObjCtx saveToPersistentStore:&executeError]) {
        NSLog(@"Failed to save to data store");
    }
}

- (NSManagedObjectContext*)setupRestKit
{
    NSError *error = nil;
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ArgosModel" ofType:@"momd"]];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    // Initialize the Core Data stack.
    [managedObjectStore createPersistentStoreCoordinator];
    
    NSPersistentStore __unused *persistentStore = [managedObjectStore addInMemoryPersistentStore:&error];
    NSAssert(persistentStore, @"Failed to add persistent store: %@", error);
    
    [managedObjectStore createManagedObjectContexts];
    
    // Set the default store shared instance.
    [RKManagedObjectStore setDefaultStore:managedObjectStore];
    
    // Setup the object manager.
    ARObjectManager* objectManager = [ARObjectManager objectManagerWithManagedObjectStore:managedObjectStore];
    [RKObjectManager setSharedManager:objectManager];
    
    return managedObjectStore.mainQueueManagedObjectContext;
}

@end
