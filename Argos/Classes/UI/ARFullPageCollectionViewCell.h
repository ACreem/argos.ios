//
//  ARFullPageCollectionViewCell.h
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//
//  ==========================================================
//  A full screen cell, which displays an image at full screen
//  size.
//  ==========================================================

#import "ARCollectionViewCell.h"

@protocol AREntityWithFullImage <AREntity>
-(UIImage*)imageFull;
-(void)setImageFull:(id)image;
@end

@interface ARFullPageCollectionViewCell : ARCollectionViewCell

@end
