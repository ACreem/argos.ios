//
//  ArgosObjectManager.m
//  Argos
//
//  Created by Francis Tseng on 2/12/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ArgosObjectManager.h"

#import "Event.h"
#import "Article.h"
#import "Story.h"
#import "Concept.h"
#import "Mention.h"
#import "Source.h"
#import "CurrentUser.h"

// Test values
static NSString* const kArgosAPIClientId = @"test";
static NSString* const kArgosAPIClientSecret = @"test";

@interface ArgosObjectManager ()
@property (strong, nonatomic) AFOAuth2Client* client;
@property (strong, nonatomic) CurrentUser* currentUser;
@end

@implementation ArgosObjectManager

+(ArgosObjectManager*)sharedManager {
    return (ArgosObjectManager*)[super sharedManager];
}

+ (ArgosObjectManager*)objectManagerWithManagedObjectStore:(RKManagedObjectStore*)mos
{
    //RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
    //RKLogConfigureByName("RestKit/Network", RKLogLevelWarning);
    
    // Create an Argos OAuth2 client.
    AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:[NSURL URLWithString:kArgosAPIBaseURLString] clientID:kArgosAPIClientId secret:kArgosAPIClientSecret];
    
    // Setup the object manager with the OAuth2 client.
    ArgosObjectManager *objectManager = [[ArgosObjectManager alloc] initWithHTTPClient:oauthClient];
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
        @"name": @"name"                    // map the JSON "name" to the Core Data "name".
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
                                      @"score":          @"score",
                                      @"image":          @"imageUrl",
                                      @"summary":        @"summary",
                                      @"updated_at":     @"updatedAt",
                                      @"created_at":     @"createdAt",
                                      @"@metadata.routing.parameters.query":     @"searchQuery"};
    NSDictionary *storyMappings   = @{
                                      @"id":             @"storyId",
                                      @"url":            @"jsonUrl",
                                      @"title":          @"title",
                                      @"image":          @"imageUrl",
                                      @"summary":        @"summary",
                                      @"updated_at":     @"updatedAt",
                                      @"created_at":     @"createdAt",
                                      @"@metadata.routing.parameters.query":     @"searchQuery"};
    NSDictionary *conceptMappings  = @{
                                      @"slug":           @"conceptId",
                                      @"url":            @"jsonUrl",
                                      @"name":           @"title",
                                      @"image":          @"imageUrl",
                                      @"summary":        @"summary",
                                      @"updated_at":     @"updatedAt",
                                      @"created_at":     @"createdAt",
                                      @"@metadata.routing.parameters.query":     @"searchQuery"};
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
                                                @"concept": @{
                                                    @"entity":     @"Concept",
                                                    @"mappings":   @{
                                                        @"slug": @"conceptId"}}}};
    
    
    RKEntityMapping* eventMapping = [objectManager setupEntityForName:@"Event"
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
                                                                        @"concepts":    @{
                                                                                          @"entity":      @"Concept",
                                                                                          @"mappings":    conceptMappings}}
                                                             mappings:eventMappings];
    
    RKEntityMapping *storyMapping = [objectManager setupEntityForName:@"Story"
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
                                                                        @"concepts":    @{
                                                                                          @"entity":      @"Concept",
                                                                                          @"mappings":    conceptMappings}}
                                                             mappings:storyMappings];
    
    RKEntityMapping *conceptMapping = [objectManager setupEntityForName:@"Concept"
                                                            pathPattern:@"/concepts"
                                                                  class:[Concept class]
                                                             identifier:@"conceptId"
                                                          relationships:@{
                                                                          // TODO: adapt this to a more generic "baseEntityMappings" or something.
                                                                          @"entities":   @{
                                                                                          @"entity":      @"Story",
                                                                                          @"mappings":    storyMappings}}
                                                             mappings:conceptMappings];
    
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
    
    [objectManager setupEntityForName:@"Mention"
                          pathPattern:@"/aliases"
                                class:[Mention class]
                           identifier:@"mentionId"
                        relationships:nil
                             mappings:mentionMappings];

    
    // Setup the search results mapping.
    // =================================
    // The search endpoint requires special handling,
    // since it returns representations of multiple different resources.
    RKDynamicMapping *searchMapping = [RKDynamicMapping new];
    
    [searchMapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"type" expectedValue:@"event" objectMapping:eventMapping]];
    [searchMapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"type" expectedValue:@"story" objectMapping:storyMapping]];
    [searchMapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"type" expectedValue:@"entity" objectMapping:conceptMapping]];
    
    RKResponseDescriptor *searchResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:searchMapping method:RKRequestMethodGET pathPattern:@"/search/:query" keyPath:@"results" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:searchResponseDescriptor];
    
    // Since we are extracting the search query using RestKit's `@metadata`, we *MUST* specify an RKRoute.
    // Otherwise, `@metadata` is unavailable.
    RKRoute *searchRoute = [RKRoute routeWithName:@"search" pathPattern:@"/search/:query" method:RKRequestMethodGET];
    [objectManager.router.routeSet addRoute:searchRoute];
    
    
    // Setup current user mapping.
    // =================================
    // We also setup Bookmarked and Watching with the CurrentUser mapping,
    // since those results belong to the CurrentUser.
    RKEntityMapping *currentUserMapping = [RKEntityMapping mappingForEntityForName:@"CurrentUser" inManagedObjectStore:mos];
    [currentUserMapping addAttributeMappingsFromDictionary:userMappings];
    currentUserMapping.identificationAttributes = @[ @"userId" ];
    
    // The currently authenticated user route.
    // =================================
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[CurrentUser class] pathPattern:@"/user" method:RKRequestMethodGET]];
    RKResponseDescriptor *currentUserResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:currentUserMapping method:RKRequestMethodGET pathPattern:@"/user" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:currentUserResponseDescriptor];
    
    // Bookmarked
    // =================================
    NSString* bookmarkedPath = @"/user/bookmarked";
    RKEntityMapping *currentUserBookmarkedMapping = [RKEntityMapping mappingForEntityForName:@"CurrentUser" inManagedObjectStore:mos];
    [currentUserBookmarkedMapping addAttributeMappingsFromDictionary:userMappings];
    currentUserBookmarkedMapping.identificationAttributes = @[ @"userId" ];
    // Setup the relationship which maps these events to the CurrentUser's "bookmarked" relationship.
    RKRelationshipMapping *bookmarkedRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"bookmarked" withMapping:eventMapping];
    [currentUserBookmarkedMapping addPropertyMapping:bookmarkedRelationshipMapping];
    
    RKResponseDescriptor *bookmarkedResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:currentUserBookmarkedMapping method:RKRequestMethodGET pathPattern:bookmarkedPath keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:bookmarkedResponseDescriptor];
    
    RKRoute *bookmarkedRoute = [RKRoute routeWithName:kArgosBookmarkedStream pathPattern:bookmarkedPath method:RKRequestMethodGET];
    [objectManager.router.routeSet addRoute:bookmarkedRoute];
    
    // Watching
    // ===========================
    NSString* watchingPath = @"/user/feed";
    RKEntityMapping *currentUserWatchingMapping = [RKEntityMapping mappingForEntityForName:@"CurrentUser" inManagedObjectStore:mos];
    [currentUserWatchingMapping addAttributeMappingsFromDictionary:userMappings];
    currentUserWatchingMapping.identificationAttributes = @[ @"userId" ];
    // Setup the relationship which maps these events to the CurrentUser's "watching" relationship.
    RKRelationshipMapping *watchingRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"watching" withMapping:storyMapping];
    [currentUserWatchingMapping addPropertyMapping:watchingRelationshipMapping];
    
    RKResponseDescriptor *watchingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:currentUserWatchingMapping method:RKRequestMethodGET pathPattern:watchingPath keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:watchingResponseDescriptor];
    
    RKRoute *watchingRoute = [RKRoute routeWithName:kArgosWatchingStream pathPattern:watchingPath method:RKRequestMethodGET];
    [objectManager.router.routeSet addRoute:watchingRoute];
    
    // Latest
    // ===========================
    NSString* latestPath = @"/latest";
    RKResponseDescriptor *latestResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:eventMapping method:RKRequestMethodGET pathPattern:latestPath keyPath:@"results" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:latestResponseDescriptor];
    
    RKRoute *latestRoute = [RKRoute routeWithName:kArgosLatestStream pathPattern:latestPath method:RKRequestMethodGET];
    [objectManager.router.routeSet addRoute:latestRoute];
    
    // Trending
    // ===========================
    NSString* trendingPath = @"/trending";
    RKResponseDescriptor *trendingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:eventMapping method:RKRequestMethodGET pathPattern:trendingPath keyPath:@"results" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:trendingResponseDescriptor];
    
    RKRoute *trendingRoute = [RKRoute routeWithName:kArgosTrendingStream pathPattern:trendingPath method:RKRequestMethodGET];
    [objectManager.router.routeSet addRoute:trendingRoute];
    
    
    // Setup pagination mapping.
    // =================================
    RKObjectMapping *paginationMapping = [RKObjectMapping mappingForClass:[RKPaginator class]];
    [paginationMapping addAttributeMappingsFromDictionary:@{
                                                            @"pagination.per_page": @"perPage",
                                                            @"pagination.page": @"currentPage",
                                                            @"pagination.total_count": @"objectCount",
                                                            }];
    [objectManager setPaginationMapping:paginationMapping];
    
    return objectManager;
}

// Helper to get the OAuth2 client.
- (AFOAuth2Client*)client {
    return (AFOAuth2Client*)self.HTTPClient;
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
- (RKEntityMapping*)setupEntityForName:(NSString*)name pathPattern:(NSString*)pathPattern class:(Class)class identifier:(NSString*)identifier relationships:(NSDictionary*)relationships mappings:(NSDictionary*)mappings
{
    // Setup the entity mapping.
    RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:name inManagedObjectStore:self.managedObjectStore];
    [entityMapping addAttributeMappingsFromDictionary:mappings];
    entityMapping.identificationAttributes = @[ identifier ];
    
    // Setup the entity's nested relationship mappings.
    for (NSString* relationshipName in relationships) {
        RKEntityMapping *relatedEntityMapping = [RKEntityMapping mappingForEntityForName:relationships[relationshipName][@"entity"] inManagedObjectStore:self.managedObjectStore];
        
        // Check for nested-nested relationship mappings.
        NSMutableDictionary* relationshipMappingDict = [relationships[relationshipName][@"mappings"] mutableCopy];
        NSDictionary* nestedRelationships = [relationshipMappingDict objectForKey:@"relationships"];
        [relationshipMappingDict removeObjectForKey:@"relationships"];
        
        // Add top-level mappings.
        [relatedEntityMapping addAttributeMappingsFromDictionary:relationshipMappingDict];
        
        // Create nested-nested relationships.
        if (nestedRelationships) {
            for (NSString* nestedRelationshipName in nestedRelationships) {
                RKEntityMapping *nestedEntityMapping = [RKEntityMapping mappingForEntityForName:nestedRelationships[nestedRelationshipName][@"entity"] inManagedObjectStore:self.managedObjectStore];
                [nestedEntityMapping addAttributeMappingsFromDictionary:nestedRelationships[nestedRelationshipName][@"mappings"]];
                RKRelationshipMapping *nestedRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:nestedRelationshipName withMapping:nestedEntityMapping];
                [relatedEntityMapping addPropertyMapping:nestedRelationshipMapping];
            }
        }
        
        [entityMapping addRelationshipMappingWithSourceKeyPath:relationshipName mapping:relatedEntityMapping];
    }
    
    // Setup collection route.
    // e.g. /events
    // Collection routes responses look like:
    /*
        {
            "results": [ ... ],
            "pagination": { ... }
        } 
     */
    RKResponseDescriptor *collectionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping method:RKRequestMethodGET pathPattern:pathPattern keyPath:@"results" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self addResponseDescriptor:collectionResponseDescriptor];
    
    // Setup member route.
    // e.g. /events/:eventId
    NSString* memberPathPattern = [NSString stringWithFormat:@"%@/:%@", pathPattern, identifier];
    [self.router.routeSet addRoute:[RKRoute routeWithClass:class pathPattern:memberPathPattern method:RKRequestMethodGET]];
    RKResponseDescriptor *memberResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping method:RKRequestMethodGET pathPattern:memberPathPattern keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self addResponseDescriptor:memberResponseDescriptor];
    
    return entityMapping;
}

@end
