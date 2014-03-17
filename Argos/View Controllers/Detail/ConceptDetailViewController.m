//
//  ConceptDetailViewController.m
//  Argos
//
//  Created by Francis Tseng on 2/17/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ConceptDetailViewController.h"
#import "StoryDetailViewController.h"

#import "EmbeddedCollectionViewController.h"
#import "CollectionViewCell.h"

#import "Story.h"

@interface ConceptDetailViewController ()
@property (nonatomic, strong) EmbeddedCollectionViewController *mentionList;
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
    
    self.totalItems = self.entity.entities.count;
    
    if (!self.entity.summary) {
        self.entity.summary = @"We have no summary for this entity yet. Please help by submitting one!";
    }
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(CGRectGetWidth(self.view.frame), kMidCellHeight)];
    
    // Mentions (story) list
    self.mentionList = [[EmbeddedCollectionViewController alloc] initWithCollectionViewLayout:flowLayout forEntityNamed:@"Story" withPredicate:[NSPredicate predicateWithFormat:@"SELF IN %@", self.entity.entities]];
    self.mentionList.managedObjectContext = self.entity.managedObjectContext;
    self.mentionList.delegate = self;
    self.mentionList.title = @"Mentions";
    
    [self.mentionList.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self addChildViewController:self.mentionList];
    [self.view.scrollView addSubview:self.mentionList.collectionView];
    [self.mentionList didMoveToParentViewController:self];
    [self.mentionList.collectionView sizeToFit];
    [self getEntities:self.entity.entities forCollectionView:self.mentionList];
    
    // Refreshes the summary view.
    self.view.entity = self.entity;
}

# pragma mark - EmbeddedCollectionViewControllerDelegate
- (CollectionViewCell*)configureCell:(CollectionViewCell *)cell atIndexPath:(NSIndexPath*)indexPath forEmbeddedCollectionViewController:(EmbeddedCollectionViewController *)embeddedCollectionViewController
{
    if (embeddedCollectionViewController == self.mentionList) {
        Story *story = [embeddedCollectionViewController.fetchedResultsController objectAtIndexPath:indexPath];
        
        [self.mentionList handleImageForEntity:story forCell:cell atIndexPath:indexPath];
        
        cell.yPadding = 6;
        cell.titleLabel.text = story.title;
        cell.titleLabel.font = [UIFont titleFontForSize:18];
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
