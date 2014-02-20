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

#ifdef DEBUG
    static NSString* const kArgosAPIBaseURLString = @"http://ny-m-ftseng.local:5000";
#else
    static NSString* const kArgosAPIBaseURLString = @"http://api.argos.com/";
#endif

@interface ARObjectManager () {
    CurrentUser* _currentUser;
}
@end

@implementation ARObjectManager

+(ARObjectManager*)sharedManager {
    return (ARObjectManager*)[super sharedManager];
}

+ (ARObjectManager*)objectManagerWithManagedObjectStore:(RKManagedObjectStore*)mos
{
    //RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/Network", RKLogLevelWarning);
    
    // Set up the object manager.
    ARObjectManager *objectManager = [ARObjectManager managerWithBaseURL:[NSURL URLWithString:kArgosAPIBaseURLString]];
    objectManager.managedObjectStore = mos;
    
    // Define API JSON response => Core Data attributes mappings.
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
                                      @"updated_at":     @"updatedAt"};
    
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
                                        @"entities":    @{
                                                          @"entity":      @"Entity",
                                                          @"mappings":    entityMappings}}
                             mappings:eventMappings];
    
    [objectManager setupEntityForName:@"Article"
                          pathPattern:@"/articles"
                                class:[Article class]
                           identifier:@"articleId"
                        relationships:nil
                             mappings:articleMappings];
    
    [objectManager setupEntityForName:@"Story"
                          pathPattern:@"/stories"
                                class:[Story class]
                           identifier:@"storyId"
                        relationships:@{
                                        @"events":      @{
                                                          @"entity":      @"Event",
                                                          @"mappings":    eventMappings},
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
    
    return objectManager;
}

// Temporary for handling the current user.
// Eventually this should be handled through RestKit, GETing and POSTing the CurrentUser to the `/user` endpoint.
- (CurrentUser*)currentUser {
    if (!_currentUser) {
        NSEntityDescription* entityDesc = [NSEntityDescription entityForName:@"CurrentUser" inManagedObjectContext:self.managedObjectStore.mainQueueManagedObjectContext];
        _currentUser = [[CurrentUser alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:self.managedObjectStore.mainQueueManagedObjectContext];
    }
    return _currentUser;
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
        [relationshipMapping addAttributeMappingsFromDictionary:relationships[relationshipName][@"mappings"]];
        [entityMapping addRelationshipMappingWithSourceKeyPath:relationshipName mapping:relationshipMapping];
    }
    
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
