//
//  StreamViewController.m
//  Argos
//
//  Created by Francis Tseng on 3/1/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "StreamViewController.h"
#import "CurrentUser+Management.h"
#import "EAIntroView+ARIntro.h"

@interface StreamViewController ()
@property (strong, nonatomic) NSString* stream;
@property (strong, nonatomic) RKPaginator *paginator;
@property (assign, nonatomic) BOOL isLoading;
@end

@implementation StreamViewController

- (instancetype)initWithStream:(NSString *)stream
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [flowLayout setSectionInset:UIEdgeInsetsZero];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    NSPredicate *predicate;
    NSString* title;
    if ([stream isEqualToString:kArgosWatchingStream]) {
        predicate = [NSPredicate predicateWithFormat:@"ANY self.stories IN %@", [CurrentUser currentUser].watching];
        self.sortKey = @"createdAt";
        title = @"Watching";
        
    } else if ([stream isEqualToString:kArgosLatestStream]) {
        predicate = [NSPredicate predicateWithFormat:@"createdAt != nil"];
        self.sortKey = @"createdAt";
        title = @"Latest";
        
    } else if ([stream isEqualToString:kArgosTrendingStream]) {
        predicate = [NSPredicate predicateWithFormat:@"score != nil"];
        self.sortKey = @"score";
        title = @"Trending";
        
    } else if ([stream isEqualToString:kArgosBookmarkedStream]) {
        predicate = [NSPredicate predicateWithFormat:@"self in %@", [CurrentUser currentUser].bookmarked];
        self.sortKey = @"createdAt";
        title = @"Bookmarks";
    }

    self = [super initWithCollectionViewLayout:flowLayout forEntityNamed:@"Event" withPredicate:predicate];
    if (self) {
        _stream = stream;
        self.navigationItem.title = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // If the user is new, show the intro/onboarding.
    if (self.isNewUser) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        EAIntroView* intro = [EAIntroView introductionWithFrame:self.view.bounds];
        intro.delegate = self;
        [intro showInView:self.view animateDuration:0.0];
    }
}

- (void)loadData
{
    // Create weak reference to self to use within the paginator's completion block
    __weak typeof(self) weakSelf = self;
    
    // Setup paginator
    if (!self.paginator) {
        
        ArgosObjectManager *objectManager = [ArgosObjectManager sharedManager];
        NSString *requestString = [NSString stringWithFormat:@"%@?page=:currentPage", self.stream];
        self.paginator = [objectManager paginatorWithPathPattern:requestString];
        
        [self.paginator setCompletionBlockWithSuccess:^(RKPaginator *paginator, NSArray *objects, NSUInteger page) {
            if (page == 1) {
                [NSFetchedResultsController deleteCacheWithName:@"Master"];
            }
            [weakSelf.collectionView reloadData];
            [weakSelf.refreshControl endRefreshing];
            weakSelf.isLoading = NO;
            
        } failure:^(RKPaginator *paginator, NSError *error) {
            [weakSelf.refreshControl endRefreshing];
            NSInteger statusCode = [(NSHTTPURLResponse*)error.userInfo[@"AFNetworkingOperationFailingURLResponseErrorKey"] statusCode];
            if (statusCode == 404 && paginator.currentPage == 1) {
                CGRect screenRect = [UIScreen mainScreen].bounds;
                CGFloat padding = 12;
                UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, screenRect.size.height/2 - 36 - padding, screenRect.size.width - 2*padding, 36)];
                if ([weakSelf.stream isEqualToString:kArgosBookmarkedStream]) {
                    loadingLabel.text = @"You don't have any bookmarks yet.";
                } else if ([weakSelf.stream isEqualToString:kArgosWatchingStream]) {
                    loadingLabel.text = @"You aren't watching any stories yet.";
                }
                loadingLabel.font = [UIFont titleFontForSize:14.0];
                loadingLabel.textAlignment = NSTextAlignmentCenter;
                loadingLabel.backgroundColor = [UIColor actionColor];
                loadingLabel.textColor = [UIColor whiteColor];
                [weakSelf.collectionView addSubview:loadingLabel];
                [weakSelf.collectionView bringSubviewToFront:loadingLabel];
            } else {
                NSLog(@"Failure getting page: %@", error);
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An Error Has Occurred" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }
    
    [self.paginator loadPage:1];
}

# pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > (0.8 * scrollView.contentSize.height) && !self.isLoading && self.paginator.hasNextPage) {
        self.isLoading = YES;
        [self.paginator loadNextPage];
    }
}

# pragma mark - EAIntroDelegate
- (void)introDidFinish:(EAIntroView *)introView
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

@end
