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

// For the intro pages.
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIFont *descFont;

@end

@implementation StreamViewController

- (id)initWithStream:(NSString *)stream
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [flowLayout setSectionInset:UIEdgeInsetsZero];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.stream = stream;
    
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
        self.navigationItem.title = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // If the user is new, show the intro/onboarding.
    if (self.userIsNew) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        
        _titleFont = [UIFont fontWithName:@"Graphik-LightItalic" size:24];
        _descFont = [UIFont fontWithName:@"Graphik-Light" size:17];
        
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
    [[ARObjectManager sharedManager] getObjectsAtPathForRouteNamed:self.stream object:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
        [self.refreshControl endRefreshing];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        NSLog(@"%@", error);
        [self.refreshControl endRefreshing];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An Error Has Occurred" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}

# pragma mark - EAIntroDelegate

- (void)introDidFinish:(EAIntroView *)introView
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

// Helper for creating intro pages.
- (EAIntroPage*)createPageWithTitle:(NSString*)title description:(NSString*)description imageNamed:(NSString*)imageName
{
    float padding = 50;
    UIView *customView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    // Setup the title label.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, self.view.bounds.size.height/2 + 60, self.view.bounds.size.width - 2*padding, 60)];
    titleLabel.font = _titleFont;
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // Create a border the same width as the title.
    CALayer *bottomBorder = [CALayer layer];
    CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName: _titleFont}].width;
    bottomBorder.frame = CGRectMake(self.view.bounds.size.width/2 - width/2 - padding, titleLabel.frame.size.height - 20, width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.227 green:0.404 blue:0.984 alpha:1.0].CGColor;
    [titleLabel.layer addSublayer:bottomBorder];
    
    [customView addSubview:titleLabel];
    
    // Setup the description label.
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, titleLabel.frame.origin.y + titleLabel.frame.size.height, self.view.bounds.size.width - 2*padding, 60)];
    descLabel.font = _descFont;
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
