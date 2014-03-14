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
@property (nonatomic, strong) Concept *concept;
@property (nonatomic, strong) AREmbeddedCollectionViewController *mentionList;
@end

@implementation ConceptDetailViewController

- (ConceptDetailViewController*)initWithConcept:(Concept*)concept;
{
    self = [super init];
    if (self) {
        // Load requested entity
        self.viewTitle = concept.title;
        _concept = concept;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[RKObjectManager sharedManager] getObject:_concept path:_concept.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
        [self setupView];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];
}

#pragma mark - Setup
- (void)setupView
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    self.totalItems = _concept.stories.count;
    
    [self setHeaderImageForEntity:_concept];
    
    // Summary view
    CGPoint summaryOrigin = CGPointMake(bounds.origin.x, self.headerView.bounds.size.height);
    NSString *summaryText = @"We have no summary for this entity yet. Please help by submitting one!";
    if (_concept.summary) {
        summaryText = _concept.summary;
    }
    self.summaryView = [[ARSummaryView alloc] initWithOrigin:summaryOrigin text:summaryText updatedAt:_concept.updatedAt];
    
    [self.scrollView addSubview:self.summaryView];
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(bounds.size.width, 120)];
    
    // Mentions (story) list header
    _mentionList = [[AREmbeddedCollectionViewController alloc] initWithCollectionViewLayout:flowLayout forEntityNamed:@"Story" withPredicate:[NSPredicate predicateWithFormat:@"SELF IN %@", _concept.stories]];
    _mentionList.managedObjectContext = _concept.managedObjectContext;
    _mentionList.delegate = self;
    _mentionList.title = @"Mentions";
    
    [_mentionList.collectionView registerClass:[AREmbeddedCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [self addChildViewController:_mentionList];
    [self.scrollView addSubview:_mentionList.collectionView];
    [_mentionList didMoveToParentViewController:self];
    [self fetchMentions];
}

- (void)fetchMentions
{
    __block NSUInteger fetched_mention_count = 0;
    for (Story* story in _concept.stories) {
        [[RKObjectManager sharedManager] getObject:story path:story.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            fetched_mention_count++;
            
            self.loadedItems++;
            [self.progressView setProgress:self.loadedItems/self.totalItems animated:YES];
            
            if (fetched_mention_count == [_concept.stories count]) {
                [_mentionList.collectionView reloadData];
                [_mentionList.collectionView sizeToFit];
                [self.scrollView sizeToFit];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
    }
}

# pragma mark - AREmbeddedCollectionViewControllerDelegate
- (ARCollectionViewCell*)configureCell:(AREmbeddedCollectionViewCell *)cell atIndexPath:(NSIndexPath*)indexPath forEmbeddedCollectionViewController:(AREmbeddedCollectionViewController *)embeddedCollectionViewController
{
    if (embeddedCollectionViewController == _mentionList) {
        Story *story = [embeddedCollectionViewController.fetchedResultsController objectAtIndexPath:indexPath];
        
        [_mentionList handleImageForEntity:(id)story forCell:cell atIndexPath:indexPath];
        
        cell.titleLabel.text = story.title;
        cell.timeLabel.text = [story.updatedAt timeAgo];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Story *story = [[_concept.stories allObjects] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[[StoryDetailViewController alloc] initWithStory:story] animated:YES];
}


@end
