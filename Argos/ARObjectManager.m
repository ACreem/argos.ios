//
//  ARObjectManager.m
//  Argos
//
//  Created by Francis Tseng on 2/12/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARObjectManager.h"

#import "Event.h"
#import "Article.h"
#import "Story.h"
#import "Entity.h"
#import "Mention.h"
#import "Source.h"
#import "CurrentUser.h"

// Test values
static NSString* const kArgosAPIClientId = @"test";
static NSString* const kArgosAPIClientSecret = @"test";

@interface ARObjectManager ()
@property (strong, nonatomic) AFOAuth2Client* client;
@property (strong, nonatomic) CurrentUser* currentUser;
@end

@implementation ARObjectManager

+(ARObjectManager*)sharedManager {
    return (ARObjectManager*)[super sharedManager];
}

+ (ARObjectManager*)objectManagerWithManagedObjectStore:(RKManagedObjectStore*)mos
{
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    //RKLogConfigureByName("RestKit/Network", RKLogLevelWarning);
    
    // Create an Argos OAuth2 client.
    AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:[NSURL URLWithString:kArgosAPIBaseURLString] clientID:kArgosAPIClientId secret:kArgosAPIClientSecret];
    
    // Set up the object manager with the OAuth2 client.
    ARObjectManager *objectManager = [[ARObjectManager alloc] initWithHTTPClient:oauthClient];
    objectManager.managedObjectStore = mos;
    
    // Define API JSON response => Core Data attributes mappings.
    /*
     A note on nested relationships in mappings.
     These nested relationships are only valid as being passed in as the `relationships` argument
     for:
     - (void)setupEntityForName:(NSString*)name pathPattern:(NSString*)pathPattern class:(Class)class identifier:(NSString*)identifier relationships:(NSDictionary*)relationships mappings:(NSDictionary*)mappings
     
     Say you have a JSON representation of a "Widget", such as:
     
     {
        "id": 1,
        "name": "some name",
        "thing_id": 1
     }
     
     You have a resource which has a nested resource, a "Thing".
     
     Say you have two Core Data (CD) models:
     
     Widget:
        widgetId:     NSInteger
        name:         NSString
        thing:        Thing
     
     Thing:
        thingId:      NSInteger
        widget:       Widget
     
     To properly map the Widget JSON to cover both the creation of
     the Widget and the Thing, you would do:
     
     @{
        @"name": @"name"                    // map the JSON "name" to the CD "name".
        @"relationships": @{                // "relationships" is a special key indicating nested relationships.
            @"thing": @{                    // the relationship name that's being mapped.
                @"entity": @"Thing",        // the name of the nested/related entity that's being mapped to.
                @"mappings": @{             // the mappings for the nested/related entity.
                    @"thing_id": @"thingId"
                }
            }
        }
     }
    */
    
    NSDictionary *articleMappings = @{
                                      @"id":             @"articleId",
                                      @"url":            @"jsonUrl",
                                      @"title":          @"title",
                                      @"ext_url":        @"extUrl",
                                      @"created_at":     @"createdAt"};
    NSDictionary *eventMappings   = @{
                                      @"id":             @"eventId",
                                      @"url":            @"jsonUrl",
                                      @"title":          @"title",
                                      @"image":          @"imageUrl",
                                      @"summary":        @"summary",
                                      @"updated_at":     @"updatedAt",
                                      @"created_at":     @"createdAt"};
    NSDictionary *storyMappings   = @{
                                      @"id":             @"storyId",
                                      @"url":            @"jsonUrl",
                                      @"title":          @"title",
                                      @"image":          @"imageUrl",
                                      @"summary":        @"summary",
                                      @"updated_at":     @"updatedAt",
                                      @"created_at":     @"createdAt"};
    NSDictionary *entityMappings  = @{
                                      @"slug":           @"entityId",
                                      @"url":            @"jsonUrl",
                                      @"name":           @"name",
                                      @"image":          @"imageUrl",
                                      @"summary":        @"summary",
                                      @"updated_at":     @"updatedAt"};
    NSDictionary *sourceMappings  = @{
                                      @"id":             @"sourceId",
                                      @"url":            @"jsonUrl",
                                      @"name":           @"name",
                                      @"ext_url":        @"extUrl"};
    NSDictionary *mentionMappings = @{
                                      @"name":           @"name"};
    NSDictionary *userMappings    = @{
                                      @"id":             @"userId"};
    
    NSDictionary *nestedMentionMappings = @{
                                            @"name":           @"name",
                                            @"relationships":  @{
                                                @"parent": @{
                                                    @"entity":     @"Entity",
                                                    @"mappings":   @{
                                                        @"entity_slug": @"entityId"}}}};
    
    
    [objectManager setupEntityForName:@"Event"
                          pathPattern:@"/events"
                                class:[Event class]
                           identifier:@"eventId"
                        relationships:@{
                                        @"articles":    @{
                                                          @"entity":      @"Article",
                                                          @"mappings":    articleMappings},
                                        @"stories":     @{
                                                          @"entity":      @"Story",
                                                          @"mappings":    storyMappings},
                                        @"mentions":    @{
                                                          @"entity":      @"Mention",
                                                          @"mappings":    nestedMentionMappings},
                                        @"entities":    @{
                                                          @"entity":      @"Entity",
                                                          @"mappings":    entityMappings}}
                             mappings:eventMappings];
    
    [objectManager setupEntityForName:@"Article"
                          pathPattern:@"/articles"
                                class:[Article class]
                           identifier:@"articleId"
                        relationships:@{
                                        @"source": @{
                                                     @"entity":   @"Source",
                                                     @"mappings": sourceMappings}}
                             mappings:articleMappings];
    
    [objectManager setupEntityForName:@"Source"
                          pathPattern:@"/sources"
                                class:[Source class]
                           identifier:@"sourceId"
                        relationships:nil
                             mappings:sourceMappings];
    
    [objectManager setupEntityForName:@"Story"
                          pathPattern:@"/stories"
                                class:[Story class]
                           identifier:@"storyId"
                        relationships:@{
                                        @"events":      @{
                                                          @"entity":      @"Event",
                                                          @"mappings":    eventMappings},
                                        @"mentions":    @{
                                                          @"entity":      @"Mention",
                                                          @"mappings":    nestedMentionMappings},
                                        @"entities":    @{
                                                          @"entity":      @"Entity",
                                                          @"mappings":    entityMappings}}
                             mappings:storyMappings];
    
    [objectManager setupEntityForName:@"Entity"
                          pathPattern:@"/entities"
                                class:[Entity class]
                           identifier:@"entityId"
                        relationships:@{
                                        @"stories":   @{
                                                        @"entity":      @"Story",
                                                        @"mappings":    storyMappings}}
                             mappings:entityMappings];
    
    [objectManager setupEntityForName:@"Mention"
                          pathPattern:@"/aliases"
                                class:[Mention class]
                           identifier:@"mentionId"
                        relationships:nil
                             mappings:mentionMappings];
    
    [objectManager setupEntityForName:@"CurrentUser"
                          pathPattern:@"/user"
                                class:[CurrentUser class]
                           identifier:@"userId"
                        relationships:nil
                             mappings:userMappings];
    
    return objectManager;
}

// Helper to get the OAuth2 client.
- (AFOAuth2Client*)client {
    return (AFOAuth2Client*)self.HTTPClient;
}

- (CurrentUser*)currentUser {
    if (_currentUser) {
        return _currentUser;
    }
    
    NSManagedObjectContext *moc = self.managedObjectStore.mainQueueManagedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"CurrentUser"
                                        inManagedObjectContext:moc]];
    NSError *error = nil;
    NSArray *userArray = [moc executeFetchRequest:fetchRequest error:&error];
    if (!error) {
        NSAssert([userArray count] == 1, @"Expected one current user but there were more");
        _currentUser = [userArray objectAtIndex:0];
    }
    
    return _currentUser;
}

- (void)logoutCurrentUser {
    if (_currentUser) {
        [AFOAuthCredential deleteCredentialWithIdentifier:self.client.serviceProviderIdentifier];
        [self.managedObjectStore.mainQueueManagedObjectContext deleteObject:_currentUser];
        _currentUser = nil;
    }
}

- (void)loginCurrentUserWithEmail:(NSString*)email
                         password:(NSString*)password
                          success:(void (^)(CurrentUser *currentUser))success
                          failure:(void (^)(NSError *error))failure
{
    [self logoutCurrentUser];
    
    [self.client authenticateUsingOAuthWithPath:@"/oauth/token"
                                       username:email
                                       password:password
                                          scope:@"userinfo"
                                        success:^(AFOAuthCredential *credential) {
                                            // Save the credential.
                                            [AFOAuthCredential storeCredential:credential withIdentifier:self.client.serviceProviderIdentifier];
                                            
                                            // Create the current user.
                                            _currentUser = [NSEntityDescription insertNewObjectForEntityForName:@"CurrentUser" inManagedObjectContext:self.managedObjectStore.mainQueueManagedObjectContext];
                                            
                                            // Get the current user's info.
                                            if (_currentUser) {
                                                [self getObject:_currentUser path:@"/user" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                    NSLog(@"Current user successfully got, with id %@", _currentUser.userId);
                                                    
                                                    if (success) {
                                                        success(_currentUser);
                                                    }
                                                } failure:^(RKObjectRequestOperation *operation, NSError *error) {
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

/*
 Convenience method for setting up resource/entity handling in RestKit.
 This will setup the API JSON => Core Data attribute mappings, nested relationship mappings,
 response descriptors, collection route, and member routes for the entity/resource.
 
 Args:
    name            (NSString)      - the Core Data entity name                      e.g. "Event"
    pathPattern     (NSString)      - the route for the resource's collection        e.g. "/events"
    class           (Class)         - the class of the entity                        e.g. [Event class]
    identifier      (NSString)      - the primary key attribute of the entity        e.g. "eventId"
    relationships   (NSDictionary)  - the relationship descriptions & mappings for the entity,
                                        in the format:
                                        @{relationshipName: @{@"entity": NSString entity name, @"mappings": NSDictionary of mappings
    mappings        (NSDictionary)  - the mappings of the API JSON representation of the resource
                                        to the Core Data attributes of the entity
 
 This is a pretty important method so here's a bunch more detail.
 
 The resource relationship setup here assumes that the related resources are represented as nested JSON, thus RestKit's relationship mapping is used. This is as opposed to being represented solely as foreign keys (in which case RestKit's connection descriptions are more appropriate).
 
 To illustrate, this is the difference between:
 
 Nested JSON representation:
 {
    "title": "some event title",
    "articles": {
        { "id": 5 },
        { "id": 6 }
    }
 }
 
 Foreign keys:
 {
    "title": "some event title",
    "articles": [5, 6]
 }
 Note that this requires that there is a transient "articles" attribute (NSArray) on the Event Core Data model.
 
 The benefit of the former approach is that it supports loading in partial representations of nested resources:
 {
     "title": "some event title",
     "articles": {
         { "id": 5, "title": "foo" },
         { "id": 6, "title": "bar" }
     }
 }
 And these nested entities will be created by RestKit with this partial data.
 
 You can individually GET each of these nested entities to fill in the rest of their data:
 
 for (Article* a in event.articles) {
    [[RKObjectManager sharedManager] getObject:a path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];
 }
 
 Furthermore, you can use alternative identifiers for the nested resources, e.g. a url (here, the Core Data mapped attribute for the url is named "jsonUrl" to prevent conflicts):
 {
    "title": "some event title",
    "articles": {
        { "url": "/articles/5", "title": "foo" },
        { "url": "/articles/6", "title": "bar" }
    }
 }
 
 In which case the individual getting of entities becomes:
 
 for (Article* a in event.articles) {
    [[RKObjectManager sharedManager] getObject:a path:a.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];
 }
 
 
 "Nested-nested" relationships can also be mapped, i.e. when a nested relationship itself has a nested relationship.
 
 For example:
 
 {
    "title": "some event title",
    "mentions": [{
        "name": "some mention name",
        "entity_slug": "an_entity_slug"
    }]
 }
 */
- (void)setupEntityForName:(NSString*)name pathPattern:(NSString*)pathPattern class:(Class)class identifier:(NSString*)identifier relationships:(NSDictionary*)relationships mappings:(NSDictionary*)mappings
{
    // Setup the entity mapping.
    RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:name inManagedObjectStore:self.managedObjectStore];
    [entityMapping addAttributeMappingsFromDictionary:mappings];
    entityMapping.identificationAttributes = @[ identifier ];
    
    // Setup the entity's nested relationship mappings.
    for (NSString* relationshipName in relationships) {
        RKEntityMapping *relationshipMapping = [RKEntityMapping mappingForEntityForName:relationships[relationshipName][@"entity"] inManagedObjectStore:self.managedObjectStore];
        
        // Check for nested-nested relationship mappings.
        NSMutableDictionary* relationshipMappingDict = [relationships[relationshipName][@"mappings"] mutableCopy];
        NSDictionary* nestedRelationships = [relationshipMappingDict objectForKey:@"relationships"];
        [relationshipMappingDict removeObjectForKey:@"relationships"];
        
        // Add top-level mappings.
        [relationshipMapping addAttributeMappingsFromDictionary:relationshipMappingDict];
        
        // Create nested-nested relationships.
        if (nestedRelationships) {
            for (NSString* nestedRelationshipName in nestedRelationships) {
                RKEntityMapping *nestedEntityMapping = [RKEntityMapping mappingForEntityForName:nestedRelationships[nestedRelationshipName][@"entity"] inManagedObjectStore:self.managedObjectStore];
                [nestedEntityMapping addAttributeMappingsFromDictionary:nestedRelationships[nestedRelationshipName][@"mappings"]];
                RKRelationshipMapping *nestedRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:nestedRelationshipName withMapping:nestedEntityMapping];
                [relationshipMapping addPropertyMapping:nestedRelationshipMapping];
            }
        }
        [entityMapping addRelationshipMappingWithSourceKeyPath:relationshipName mapping:relationshipMapping];
    }
    
    /*
     if there exists a @"relationships" key in the mapping, recurse
     */
    
    // Setup collection route.
    // e.g. /events
    RKResponseDescriptor *collectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping method:RKRequestMethodGET pathPattern:pathPattern keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self addResponseDescriptor:collectionResponseDescriptor];
    
    // Setup member route.
    // e.g. /events/:eventId
    NSString* memberPathPattern = [NSString stringWithFormat:@"%@/:%@", pathPattern, identifier];
    [self.router.routeSet addRoute:[RKRoute routeWithClass:class pathPattern:memberPathPattern method:RKRequestMethodGET]];
    RKResponseDescriptor *memberResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping method:RKRequestMethodGET pathPattern:memberPathPattern keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self addResponseDescriptor:memberResponseDescriptor];
}

@end
