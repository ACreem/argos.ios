//
//  SummaryArticlesViewController.m
//  Argos
//
//  Created by Francis Tseng on 4/24/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "SummaryArticlesViewController.h"

#import "Article.h"
#import "Source.h"
#import "ArticleCollectionViewCell.h"

@interface SummaryArticlesViewController ()
@property (nonatomic, strong) SummaryView *summaryView;
@property (nonatomic, strong) EmbeddedCollectionViewController *articleList;
@end

@implementation SummaryArticlesViewController

- (instancetype)initWithEvent:(Event*)event {
    self = [super init];
    if (self) {
        _event = event;
        
        self.view = [[UIScrollView alloc] initWithFrame:self.view.frame];
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.showsVerticalScrollIndicator = NO;
        
        _summaryView = [[SummaryView alloc] initWithOrigin:CGPointMake(0, 49)]; // UITabBarHeight = 49
        _summaryView.entity = event;
        [self.view addSubview:_summaryView];
        
        CGFloat padding = 10;
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setMinimumInteritemSpacing:0.0f];
        [flowLayout setMinimumLineSpacing:padding];
        [flowLayout setSectionInset:UIEdgeInsetsMake(padding, padding, padding, padding)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [flowLayout setItemSize:CGSizeMake(CGRectGetWidth(self.view.frame) - padding*2, 80)];
        _articleList = [[EmbeddedCollectionViewController alloc] initWithCollectionViewLayout:flowLayout forEntityNamed:@"Article" withPredicate:[NSPredicate predicateWithFormat:@"SELF IN %@", _event.articles]];
        _articleList.managedObjectContext = _event.managedObjectContext;
        _articleList.collectionView.backgroundColor = [UIColor colorWithRed:0.918 green:0.918 blue:0.918 alpha:1.0];
        _articleList.delegate = self;
        
        [_articleList.collectionView registerClass:[ArticleCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        
        [self addChildViewController:_articleList];
        [self.view addSubview:_articleList.collectionView];
        [_articleList didMoveToParentViewController:self];
        [_articleList.collectionView sizeToFit];
        
        __block NSUInteger fetched_entity_count = 0;
        for (BaseEntity* entity in _event.articles) {
            [[RKObjectManager sharedManager] getObject:entity path:entity.jsonUrl parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                fetched_entity_count++;
                
                /*
                self.loadedItems++;
                self.view.progress = self.loadedItems/self.totalItems;
                 */
                
                if (fetched_entity_count == [_event.articles count]) {
                    [_articleList.collectionView reloadData];
                    [_articleList.collectionView sizeToFit];
                    [self.view sizeToFit];
                }
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                NSLog(@"Failure getting entities: %@", error);
            }];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect frame = _articleList.collectionView.frame;
    frame.origin.y = CGRectGetMaxY(_summaryView.frame);
    _articleList.collectionView.frame = frame;
    
    // For some unfathomable reason, though
    // on par for iOS development's insanity,
    // I have to manually calculate and set the contentSize.
    CGSize contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 0);
    for (UIView *subview in self.view.subviews) {
        contentSize.height += CGRectGetHeight(subview.frame);
    }
    self.view.contentSize = contentSize;
}

- (void)setEvent:(Event *)event
{
    _event = event;
    _summaryView.entity = event;
}

# pragma mark - EmbeddedCollectionViewControllerDelegate
- (ArticleCollectionViewCell*)configureCell:(ArticleCollectionViewCell *)cell atIndexPath:(NSIndexPath*)indexPath forEmbeddedCollectionViewController:(EmbeddedCollectionViewController *)embeddedCollectionViewController
{
    if (embeddedCollectionViewController == self.articleList) {
        Article *article = [embeddedCollectionViewController.fetchedResultsController objectAtIndexPath:indexPath];
        
        cell.titleLabel.text = article.title;
        cell.metaLabel.text = article.source.name;
        cell.timeLabel.text = [article.createdAt timeAgo];
        
        if (!article.imageUrl) {
            cell.imageView.hidden = YES;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.articleList.collectionView) {
        Article *article = [[self.event.articles allObjects] objectAtIndex:indexPath.row];
        /*
         WebViewController *webView = [[WebViewController alloc] initWithURL:article.extUrl];
         [self.navigationController pushViewController:webView animated:YES];
         */
    }
}

@end
