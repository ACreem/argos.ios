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
    RKLogConfigureByName("RestKit", RKLogLevelWarning);
    //RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelWarning);
    RKLogConfigureByName("RestKit/Network", RKLogLevelDebug);
    
    // Create an Argos OAuth2 client.
    AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:[NSURL URLWithString:kArgosAPIBaseURLString] clientID:kArgosAPIClientId secret:kArgosAPIClientSecret];
    
    // Setup the object manager with the OAuth2 client.
    ArgosObjectManager *objectManager = [[ArgosObjectManager alloc] initWithHTTPClient:oauthClient];
    objectManager.managedObjectStore = mos;
    
    [objectManager setEntityMapping:[objectManager eventMapping] ofClass:[Event class] forPathPattern:@"/events" withIdentifier:@"eventId"];
    [objectManager setEntityMapping:[objectManager storyMapping] ofClass:[Story class] forPathPattern:@"/stories" withIdentifier:@"storyId"];
    [objectManager setEntityMapping:[objectManager sourceMapping] ofClass:[Source class] forPathPattern:@"/sources" withIdentifier:@"sourceId"];
    [objectManager setEntityMapping:[objectManager conceptMapping] ofClass:[Concept class] forPathPattern:@"/concepts" withIdentifier:@"conceptId"];
    [objectManager setEntityMapping:[objectManager articleMapping] ofClass:[Article class] forPathPattern:@"/articles" withIdentifier:@"articleId"];
    [objectManager setEntityMapping:[objectManager mentionMapping] ofClass:[Mention class] forPathPattern:@"/aliases" withIdentifier:@"mentionId"];
    
    [objectManager mapCurrentUser];
    [objectManager mapBookmarked];
    [objectManager mapWatching];
    [objectManager mapLatest];
    [objectManager mapTrending];
    [objectManager mapSearch];
    
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

# pragma mark - Mapping current user/stream resources
- (void)mapCurrentUser
{
    RKEntityMapping *currentUserMapping = [RKEntityMapping mappingForEntityForName:@"CurrentUser" inManagedObjectStore:self.managedObjectStore];
    [currentUserMapping addAttributeMappingsFromDictionary:[self userMappings]];
    currentUserMapping.identificationAttributes = @[ @"userId" ];
    
    // The currently authenticated user route.
    [self.router.routeSet addRoute:[RKRoute routeWithClass:[CurrentUser class] pathPattern:@"/user" method:RKRequestMethodGET]];
    RKResponseDescriptor *currentUserResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:currentUserMapping method:RKRequestMethodGET pathPattern:@"/user" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self addResponseDescriptor:currentUserResponseDescriptor];
}

- (void)mapBookmarked
{
    NSString* bookmarkedPath = @"/user/bookmarked";
    RKEntityMapping *currentUserBookmarkedMapping = [RKEntityMapping mappingForEntityForName:@"CurrentUser" inManagedObjectStore:self.managedObjectStore];
    [currentUserBookmarkedMapping addAttributeMappingsFromDictionary:[self userMappings]];
    currentUserBookmarkedMapping.identificationAttributes = @[ @"userId" ];
    // Setup the relationship which maps these events to the CurrentUser's "bookmarked" relationship.
    RKRelationshipMapping *bookmarkedRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"bookmarked" withMapping:[self eventMapping]];
    [currentUserBookmarkedMapping addPropertyMapping:bookmarkedRelationshipMapping];
    
    RKResponseDescriptor *bookmarkedResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:currentUserBookmarkedMapping method:RKRequestMethodGET pathPattern:bookmarkedPath keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self addResponseDescriptor:bookmarkedResponseDescriptor];
    
    RKRoute *bookmarkedRoute = [RKRoute routeWithName:kArgosBookmarkedStream pathPattern:bookmarkedPath method:RKRequestMethodGET];
    [self.router.routeSet addRoute:bookmarkedRoute];
}

- (void)mapWatching
{
    NSString* watchingPath = @"/user/feed";
    RKEntityMapping *currentUserWatchingMapping = [RKEntityMapping mappingForEntityForName:@"CurrentUser" inManagedObjectStore:self.managedObjectStore];
    [currentUserWatchingMapping addAttributeMappingsFromDictionary:[self userMappings]];
    currentUserWatchingMapping.identificationAttributes = @[ @"userId" ];
    // Setup the relationship which maps these events to the CurrentUser's "watching" relationship.
    RKRelationshipMapping *watchingRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:nil toKeyPath:@"watching" withMapping:[self storyMapping]];
    [currentUserWatchingMapping addPropertyMapping:watchingRelationshipMapping];
    
    RKResponseDescriptor *watchingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:currentUserWatchingMapping method:RKRequestMethodGET pathPattern:watchingPath keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self addResponseDescriptor:watchingResponseDescriptor];
    
    RKRoute *watchingRoute = [RKRoute routeWithName:kArgosWatchingStream pathPattern:watchingPath method:RKRequestMethodGET];
    [self.router.routeSet addRoute:watchingRoute];
}

- (void)mapLatest
{
    NSString* latestPath = @"/latest";
    RKResponseDescriptor *latestResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self eventMapping] method:RKRequestMethodGET pathPattern:latestPath keyPath:@"results" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self addResponseDescriptor:latestResponseDescriptor];
    
    RKRoute *latestRoute = [RKRoute routeWithName:kArgosLatestStream pathPattern:latestPath method:RKRequestMethodGET];
    [self.router.routeSet addRoute:latestRoute];
}

- (void)mapTrending
{
    NSString* trendingPath = @"/trending";
    RKResponseDescriptor *trendingResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self eventMapping] method:RKRequestMethodGET pathPattern:trendingPath keyPath:@"results" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self addResponseDescriptor:trendingResponseDescriptor];
    
    RKRoute *trendingRoute = [RKRoute routeWithName:kArgosTrendingStream pathPattern:trendingPath method:RKRequestMethodGET];
    [self.router.routeSet addRoute:trendingRoute];
}

- (void)mapSearch
{
    // The search endpoint requires special handling,
    // since it returns representations of multiple different resources.
    RKDynamicMapping *searchMapping = [RKDynamicMapping new];
    [searchMapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"type" expectedValue:@"event" objectMapping:[self eventMapping]]];
    [searchMapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"type" expectedValue:@"story" objectMapping:[self storyMapping]]];
    [searchMapping addMatcher:[RKObjectMappingMatcher matcherWithKeyPath:@"type" expectedValue:@"concept" objectMapping:[self conceptMapping]]];
    
    RKResponseDescriptor *searchResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:searchMapping method:RKRequestMethodGET pathPattern:@"/search/:query" keyPath:@"results" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [self addResponseDescriptor:searchResponseDescriptor];
    
    // Since we are extracting the search query using RestKit's `@metadata`, we *MUST* specify an RKRoute.
    // Otherwise, `@metadata` is unavailable.
    RKRoute *searchRoute = [RKRoute routeWithName:@"search" pathPattern:@"/search/:query" method:RKRequestMethodGET];
    [self.router.routeSet addRoute:searchRoute];
}

# pragma mark - Mapping methods
- (RKEntityMapping*)mentionMapping
{
    return [self setupEntityForName:@"Mention"
                           identifier:@"mentionId"
                        relationships:nil
                             mappings:[self mentionMappings]];
}

- (RKEntityMapping*)eventMapping
{
    return [self setupEntityForName:@"Event"
                         identifier:@"eventId"
                      relationships:@{
                                      @"articles":    @{
                                              @"entity":      @"Article",
                                              @"mappings":    [self articleMappings]},
                                      @"stories":     @{
                                              @"entity":      @"Story",
                                              @"mappings":    [self storyMappings]},
                                      @"mentions":    @{
                                              @"entity":      @"Mention",
                                              @"mappings":    [self nestedMentionMappings]},
                                      @"concepts":    @{
                                              @"entity":      @"Concept",
                                              @"mappings":    [self conceptMappings]}}
                           mappings:[self eventMappings]];
}

- (RKEntityMapping*)storyMapping
{
    
    return [self setupEntityForName:@"Story"
                         identifier:@"storyId"
                      relationships:@{
                                      @"events":      @{
                                              @"entity":      @"Event",
                                              @"mappings":    [self eventMappings]},
                                      @"mentions":    @{
                                              @"entity":      @"Mention",
                                              @"mappings":    [self nestedMentionMappings]},
                                      @"concepts":    @{
                                              @"entity":      @"Concept",
                                              @"mappings":    [self conceptMappings]}}
                           mappings:[self storyMappings]];
}

- (RKEntityMapping*)conceptMapping
{
    return [self setupEntityForName:@"Concept"
                         identifier:@"conceptId"
                      relationships:@{
                                      @"stories":   @{
                                              @"entity":      @"Story",
                                              @"mappings":    [self storyMappings]}}
                           mappings:[self conceptMappings]];
}

- (RKEntityMapping*)articleMapping
{
    return [self setupEntityForName:@"Article"
                         identifier:@"articleId"
                      relationships:@{
                                      @"source": @{
                                              @"entity":   @"Source",
                                              @"mappings": [self sourceMappings]}}
                           mappings:[self articleMappings]];
}

- (RKEntityMapping*)sourceMapping
{
    return [self setupEntityForName:@"Source"
                         identifier:@"sourceId"
                      relationships:nil
                           mappings:[self sourceMappings]];
}

# pragma mark - Dictionary mappings
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
- (NSDictionary*)userMappings
{
    return @{
             @"id": @"userId"};
}

- (NSDictionary*)eventMappings
{
    return @{
             @"id":             @"eventId",
             @"url":            @"jsonUrl",
             @"title":          @"title",
             @"score":          @"score",
             @"image":          @"imageUrl",
             @"summary":        @"summary",
             @"updated_at":     @"updatedAt",
             @"created_at":     @"createdAt",
             @"@metadata.routing.parameters.query":     @"searchQuery"};
}

- (NSDictionary*)articleMappings
{
    return @{
             @"id":             @"articleId",
             @"url":            @"jsonUrl",
             @"title":          @"title",
             @"ext_url":        @"extUrl",
             @"created_at":     @"createdAt"};
}

- (NSDictionary*)storyMappings
{
    return @{
             @"id":             @"storyId",
             @"url":            @"jsonUrl",
             @"title":          @"title",
             @"image":          @"imageUrl",
             @"summary":        @"summary",
             @"updated_at":     @"updatedAt",
             @"created_at":     @"createdAt",
             @"@metadata.routing.parameters.query":     @"searchQuery"};
}

- (NSDictionary*)conceptMappings
{
    return @{
             @"slug":           @"conceptId",
             @"url":            @"jsonUrl",
             @"name":           @"title",
             @"image":          @"imageUrl",
             @"summary":        @"summary",
             @"updated_at":     @"updatedAt",
             @"created_at":     @"createdAt",
             @"@metadata.routing.parameters.query":     @"searchQuery"};
}

- (NSDictionary*)sourceMappings
{
    return @{
             @"id":             @"sourceId",
             @"url":            @"jsonUrl",
             @"name":           @"name",
             @"ext_url":        @"extUrl"};
}

- (NSDictionary*)mentionMappings
{
    return @{
             @"name":           @"name"};
}

- (NSDictionary*)nestedMentionMappings
{
    return @{
             @"name":           @"name",
             @"relationships":  @{
                     @"concept": @{
                             @"entity":     @"Concept",
                             @"mappings":   @{
                                     @"slug": @"conceptId"}}}};
}

# pragma mark - Convenience mapping method
/*
 Convenience method for setting up resource/entity handling in RestKit.
 This will setup the API JSON => Core Data attribute mappings and nested relationship mappings.
 
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
- (RKEntityMapping*)setupEntityForName:(NSString*)name identifier:(NSString*)identifier relationships:(NSDictionary*)relationships mappings:(NSDictionary*)mappings
{
    //NSLog(@"Creating mapping for entity named %@ with identifier %@ using mappings %@ and with relationships %@", name, identifier, mappings, relationships);
    
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
        
        NSString* keyPath = relationships[relationshipName][@"key"] ? relationships[relationshipName][@"key"] : relationshipName;
        RKRelationshipMapping *relationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:keyPath toKeyPath:relationshipName withMapping:relatedEntityMapping];
        [entityMapping addPropertyMapping:relationshipMapping];
    }
    
    return entityMapping;
}

// This sets up response descriptors, collection route, and member routes for an entity/resource mapping.
- (void)setEntityMapping:(RKEntityMapping*)entityMapping ofClass:(Class)class forPathPattern:(NSString*)pathPattern withIdentifier:(NSString*)identifier
{
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
}

@end
