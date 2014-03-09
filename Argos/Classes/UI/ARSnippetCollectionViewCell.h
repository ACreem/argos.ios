//
//  ARSnippetCollectionViewCell.h
//  Argos
//
//  Created by Francis Tseng on 2/28/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//
//  =======================================================
//  Like AREmbeddedCollectionViewCell, except it includes a
//  small text label (snippet) as well.
//  =======================================================

#import "AREmbeddedCollectionViewCell.h"

@protocol AREntityWithLargeImage <AREntity>
-(UIImage*)imageLarge;
-(void)setImageLarge:(id)image;
@end

@interface ARSnippetCollectionViewCell : AREmbeddedCollectionViewCell

@end
