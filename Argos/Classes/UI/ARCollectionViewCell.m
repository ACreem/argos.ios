//
//  ARCollectionViewCell.m
//  Argos
//
//  Created by Francis Tseng on 2/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARCollectionViewCell.h"

@implementation ARCollectionViewCell

// Crops an image to the size needed by this cell.
// Need to double dimensions for retina.
- (UIImage*)cropImage:(UIImage*)image
{
    CGSize dimensions = CGSizeMake(self.imageView.frame.size.width*2, self.imageView.frame.size.height*2);
    UIImage *croppedImage = [image scaleToCoverSize:dimensions];
    croppedImage = [croppedImage cropToSize:dimensions usingMode:NYXCropModeCenter];
    return croppedImage;
}

- (void)setImageForEntity:(id<AREntity>)entity
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage *croppedImage = [self cropImage:entity.image];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = croppedImage;
        });
    });
}

@end
