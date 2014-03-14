//
//  CurrentUser+Management.m
//  Argos
//
//  Created by Francis Tseng on 3/13/14.
//  Copyright (c) 2014 Public Science. All rights reserved.
//

#import "CurrentUser+Management.h"

@implementation CurrentUser (Management)

+ (CurrentUser*)currentUser
{
    ARObjectManager *manager = [ARObjectManager sharedManager];
    NSManagedObjectContext *moc = manager.managedObjectStore.mainQueueManagedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"CurrentUser"
                                        inManagedObjectContext:moc]];
    NSError *error = nil;
    NSArray *userArray = [moc executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error fetching current user: %@", error);
    }
    
    NSAssert([userArray count] <= 1, @"Expected one current user but there were more");
    if (![userArray count]) {
        NSLog(@"No current user was found.");
        return nil;
    }
    CurrentUser* currentUser = [userArray objectAtIndex:0];
    return currentUser;
}

+ (void)logout
{
    ARObjectManager *manager = [ARObjectManager sharedManager];
    CurrentUser *currentUser = [CurrentUser currentUser];
    if (currentUser) {
        [AFOAuthCredential deleteCredentialWithIdentifier:manager.client.serviceProviderIdentifier];
        [manager.managedObjectStore.mainQueueManagedObjectContext deleteObject:currentUser];
        currentUser = nil;
    }
}

+ (void)loginWithEmail:(NSString *)email password:(NSString *)password success:(void (^)(CurrentUser *))success failure:(void (^)(NSError *))failure
{
    [CurrentUser logout];
    ARObjectManager *manager = [ARObjectManager sharedManager];
    
    [manager.client authenticateUsingOAuthWithPath:@"/oauth/token"
                                          username:email
                                          password:password
                                             scope:@"userinfo"
                                           success:^(AFOAuthCredential *credential) {
                                               // Save the credential.
                                               [AFOAuthCredential storeCredential:credential withIdentifier:manager.client.serviceProviderIdentifier];
                                               
                                               // Create the current user.
                                               CurrentUser *currentUser = [NSEntityDescription insertNewObjectForEntityForName:@"CurrentUser"
                                                                                                        inManagedObjectContext:manager.managedObjectStore.mainQueueManagedObjectContext];
                                            
                                               // Get the current user's info.
                                               if (currentUser) {
                                                    [manager getObject:currentUser
                                                               path:@"/user"
                                                         parameters:nil
                                                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                                NSLog(@"Current user successfully got, with id %@", currentUser.userId);
                                                                if (success) {
                                                                    success(currentUser);
                                                                }
                                                            }
                                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                            NSLog(@"Error getting current user: %@", error);
                                                            if (failure) {
                                                                failure(error);
                                                            }
                                                        }];
                                               }
                                           }
                                           failure:^(NSError *error) {
                                               NSLog(@"Error authenticating: %@", error);
                                               if (failure) {
                                                   failure(error);
                                               }
                                           }];
}

@end
