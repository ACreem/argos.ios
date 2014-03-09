//
//  AREntity.h
//  Argos
//
//  Created by Francis Tseng on 3/9/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//
// Expect that Core Data entities processed by this
// view controller respond to these methods.

@protocol AREntity
-(NSString*)imageUrl;
-(UIImage*)image;
-(UIImage*)imageHeader;
-(void)setImage:(id)image;
-(void)setImageHeader:(id)image;
-(NSManagedObjectContext*)managedObjectContext;
@end

@protocol AREntityWithFullImage <AREntity>
-(UIImage*)imageFull;
-(void)setImageFull:(id)image;
@end
