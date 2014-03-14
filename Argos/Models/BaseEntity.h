//
//  BaseEntity.h
//  Argos
//
//  Created by Francis Tseng on 3/14/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Concept, Mention;

@interface BaseEntity : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) id jsonUrl;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * searchQuery;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) id imageHeader;
@property (nonatomic, retain) id imageMid;
@property (nonatomic, retain) id imageFull;
@property (nonatomic, retain) id imageLarge;
@property (nonatomic, retain) NSSet *mentions;
@property (nonatomic, retain) NSSet *concepts;
@property (nonatomic, retain) NSSet *images;
@end

@interface BaseEntity (CoreDataGeneratedAccessors)

- (void)addMentionsObject:(Mention *)value;
- (void)removeMentionsObject:(Mention *)value;
- (void)addMentions:(NSSet *)values;
- (void)removeMentions:(NSSet *)values;

- (void)addConceptsObject:(Concept *)value;
- (void)removeConceptsObject:(Concept *)value;
- (void)addConcepts:(NSSet *)values;
- (void)removeConcepts:(NSSet *)values;

- (void)addImagesObject:(NSManagedObject *)value;
- (void)removeImagesObject:(NSManagedObject *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
