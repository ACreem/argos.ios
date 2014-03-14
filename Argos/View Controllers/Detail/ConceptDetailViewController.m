//
//  ConceptDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/17/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ConceptDetailViewController.h"
#import "StoryDetailViewController.h"

#import "AREmbeddedCollectionViewController.h"
#import "AREmbeddedCollectionViewCell.h"

#import "Story.h"

@interface ConceptDetailViewController ()
@property (nonatomic, strong) AREmbeddedCollectionViewController *mentionList;
@end

@implementation ConceptDetailViewController

- (instancetype)initWithConcept:(Concept*)concept;
{
    self = [super initWithEntity:concept];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[RKObjectManager sharedManager] getObject:self.entity path:self.entity.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self setupView];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to load concept: %@", error);
    }];
}

#pragma mark - Setup
- (void)setupView
{
    self.totalItems = self.entity.entities.count;
    
    if (!self.entity.summary) {
        self.entity.summary = @"We have no summary for this entity yet. Please help by submitting one!";
    }
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(CGRectGetWidth(self.view.frame), 120)];
    
    // Mentions (story) list
    self.mentionList = [[AREmbeddedCollectionViewController alloc] initWithCollectionViewLayout:flowLayout forEntityNamed:@"Story" withPredicate:[NSPredicate predicateWithFormat:@"SELF IN %@", self.entity.entities]];
    self.mentionList.managedObjectContext = self.entity.managedObjectContext;
    self.mentionList.delegate = self;
    self.mentionList.title = @"Mentions";
    
    [self.mentionList.collectionView registerClass:[AREmbeddedCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self addChildViewController:self.mentionList];
    [self.view.scrollView addSubview:self.mentionList.collectionView];
    [self.mentionList didMoveToParentViewController:self];
    [self getEntities:self.entity.entities forCollectionView:self.mentionList];
}

# pragma mark - AREmbeddedCollectionViewControllerDelegate
- (ARCollectionViewCell*)configureCell:(AREmbeddedCollectionViewCell *)cell atIndexPath:(NSIndexPath*)indexPath forEmbeddedCollectionViewController:(AREmbeddedCollectionViewController *)embeddedCollectionViewController
{
    if (embeddedCollectionViewController == self.mentionList) {
        Story *story = [embeddedCollectionViewController.fetchedResultsController objectAtIndexPath:indexPath];
        
        [self.mentionList handleImageForEntity:(id)story forCell:cell atIndexPath:indexPath];
        
        cell.titleLabel.text = story.title;
        cell.timeLabel.text = [story.updatedAt timeAgo];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Story *story = [[self.entity.entities allObjects] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[[StoryDetailViewController alloc] initWithStory:story] animated:YES];
}


@end
