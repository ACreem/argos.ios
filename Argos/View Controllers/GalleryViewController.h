//
//  GalleryViewController.h
//  Argos
//
//  Created by Francis Tseng on 3/2/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//
//  =============================
//  Horizontal scrolling gallery.
//  =============================

@interface GalleryViewController : UICollectionViewController

@property (nonatomic, strong) NSArray *images;

- (instancetype)initWithImages:(NSSet*)images;

@end
