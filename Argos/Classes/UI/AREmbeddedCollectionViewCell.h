//
//  AREmbeddedCollectionViewCell.h
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//
//  =====================================
//  A cell for embedded collection views.
//  =====================================

#import "ARCollectionViewCell.h"

@protocol AREntityWithMidImage <AREntity>
-(UIImage*)imageMid;
-(void)setImageMid:(id)image;
@end

@interface AREmbeddedCollectionViewCell : ARCollectionViewCell

@end
