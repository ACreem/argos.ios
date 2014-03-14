//
//  ARDetailViewController.h
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//
//  ============================================================
//  Abstract super class for detail view controllers. It mainly
//  consists of a header image and a summary view, though its
//  subclasses will likely have additional elements such as
//  embedded collection views or gallery views.
//  It also consists of a progress bar though its subclasses are
//  expected to implement the bar's actual loading.
//  This view controller also sets up its navigation bar; the
//  items in the navigation bar are configurable by subclasses.
//  It also handles its presentation of modal view controllers.
//  ============================================================

#import "DetailView.h"

@class BaseEntity;

@interface ARDetailViewController : UIViewController <DetailViewProtocol>

@property (nonatomic, strong) DetailView *view;
@property (nonatomic, strong) BaseEntity *entity;

// For keeping track of loading progress.
@property (nonatomic, assign) int totalItems;

// For managing embedded collection view controllers.
@property (nonatomic, strong) NSMutableArray *embeddedCollectionViewControllers;

- (instancetype)initWithEntity:(BaseEntity*)entity;
- (void)getEntities:(NSSet*)entities forCollectionView:(ARCollectionViewController*)cvc;
- (void)getConcepts:(NSSet*)concepts;
- (NSArray*)navigationItems;

@end
