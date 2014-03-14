//
//  StreamViewController.m
//  Argos
//
//  Created by Francis Tseng on 3/1/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "StreamViewController.h"

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
        predicate = [NSPredicate predicateWithFormat:@"ANY self.stories IN %@", [[ARObjectManager sharedManager] currentUser].watching];
        self.sortKey = @"createdAt";
        title = @"Watching";
        
    } else if ([stream isEqualToString:kArgosLatestStream]) {
        predicate = [NSPredicate predicateWithValue:YES];
        self.sortKey = @"createdAt";
        title = @"Latest";
        
    } else if ([stream isEqualToString:kArgosTrendingStream]) {
        predicate = [NSPredicate predicateWithValue:YES];
        self.sortKey = @"score";
        title = @"Trending";
        
    } else if ([stream isEqualToString:kArgosBookmarkedStream]) {
        predicate = [NSPredicate predicateWithFormat:@"self in %@", [[ARObjectManager sharedManager] currentUser].bookmarked];
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
        
        EAIntroPage *page1 = [self createPageWithTitle:@"Know more with less" description:@"Argos helps you stay on top of the news without overwhelming you in content." imageNamed:@"onboarding00"];
        EAIntroPage *page2 = [self createPageWithTitle:@"Events" description:@"Keep up with everything that's happened in a story." imageNamed:@"onboarding01"];
        EAIntroPage *page3 = [self createPageWithTitle:@"Concepts" description:@"Quickly learn the concepts in a story." imageNamed:@"onboarding02"];
        EAIntroPage *page4 = [self createPageWithTitle:@"Entities" description:@"Understand the people, places, and organizations involved." imageNamed:@"onboarding03"];
        EAIntroPage *page5 = [self createPageWithTitle:@"Watch" description:@"Watch the stories that are important to you..." imageNamed:@"onboarding04"];
        EAIntroPage *page6 = [self createPageWithTitle:@"Trending" description:@"...and hear about the stories that are important to everyone else." imageNamed:@"onboarding05"];
        
        EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1, page2, page3, page4, page5, page6]];
        intro.delegate = self;
        [intro showInView:self.view animateDuration:0.0];
    }
}

- (void)loadData
{
    // Create weak reference to self to use within the paginators completion block
    __weak typeof(self) weakSelf = self;
    
    // Setup paginator
    if (!self.paginator) {
        
        ARObjectManager *objectManager = [ARObjectManager sharedManager];
        NSString *requestString = [NSString stringWithFormat:@"%@?page=:currentPage", self.stream];
        self.paginator = [objectManager paginatorWithPathPattern:requestString];
        
        [self.paginator setCompletionBlockWithSuccess:^(RKPaginator *paginator, NSArray *objects, NSUInteger page) {
            
            /*
            if (page == 1) {
                [NSFetchedResultsController deleteCacheWithName:@"Master"];
            }
             */
            [weakSelf.collectionView reloadData];
            [weakSelf.refreshControl endRefreshing];
            weakSelf.isLoading = NO;
            
        } failure:^(RKPaginator *paginator, NSError *error) {
            NSLog(@"Failure: %@", error);
            [weakSelf.refreshControl endRefreshing];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An Error Has Occurred" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }];
    }
    
    [self.paginator loadPage:1];
}

# pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > (0.8 * scrollView.contentSize.height) && !self.isLoading) {
        self.isLoading = YES;
        [self.paginator loadNextPage];
    }
}

# pragma mark - EAIntroDelegate

- (void)introDidFinish:(EAIntroView *)introView
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

// Helper for creating intro pages.
- (EAIntroPage*)createPageWithTitle:(NSString*)title description:(NSString*)description imageNamed:(NSString*)imageName
{
    
    UIFont *titleFont = [UIFont fontWithName:@"Graphik-LightItalic" size:24];
    float padding = 50;
    UIView *customView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    // Setup the title label.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, self.view.bounds.size.height/2 + 60, self.view.bounds.size.width - 2*padding, 60)];
    titleLabel.font = titleFont;
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // Create a border the same width as the title.
    CALayer *bottomBorder = [CALayer layer];
    CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName: titleFont}].width;
    bottomBorder.frame = CGRectMake(self.view.bounds.size.width/2 - width/2 - padding, titleLabel.frame.size.height - 20, width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.227 green:0.404 blue:0.984 alpha:1.0].CGColor;
    [titleLabel.layer addSublayer:bottomBorder];
    
    [customView addSubview:titleLabel];
    
    // Setup the description label.
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, titleLabel.frame.origin.y + titleLabel.frame.size.height, self.view.bounds.size.width - 2*padding, 60)];
    descLabel.font = [UIFont fontWithName:@"Graphik-Light" size:17];
    descLabel.text = description;
    descLabel.textColor = [UIColor whiteColor];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descLabel.numberOfLines = 0;
    [customView addSubview:descLabel];
    
    EAIntroPage *page = [EAIntroPage pageWithCustomView:customView];
    page.bgImage = [UIImage imageNamed:imageName];
    return page;
}

@end
