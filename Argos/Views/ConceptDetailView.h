//
//  ConceptDetailView.h
//  Argos
//
//  Created by Francis Tseng on 4/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "DetailView.h"
#import "ImageHeaderView.h"

@interface ConceptDetailView : DetailView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) ImageHeaderView *headerView;

- (void)setActionButtonTitle:(NSString*)title;

@end
