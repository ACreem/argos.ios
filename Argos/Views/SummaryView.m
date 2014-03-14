//
//  SummaryView.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "SummaryView.h"
#import "Concept.h"
#import "Mention.h"
#import "NSDate+TimeAgo.h"

@interface SummaryView ()
// Keep track of the summary html,
// which includes the processed summary text but
// does NOT include filled in styling values.
// This way we can update them as necessary when font preferences change.
@property (nonatomic, strong) NSString *summaryTextHtml;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation SummaryView

- (instancetype)initWithOrigin:(CGPoint)origin;
{
    CGFloat paddingX = 16.0;
    CGFloat paddingY = 8.0;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(origin.x, origin.y, CGRectGetWidth(bounds), 400.0); // Arbitrary height, it is set programatically later.
    self = [super initWithFrame:frame];
    if (self) {
        // Watch the user defaults, so we know when to update the font settings.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(defaultsDidChange:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
        
        // Header view with metadata.
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      CGRectGetWidth(bounds),
                                                                      30.0 + paddingY)];
        
        // Setup time ago
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingX,
                                                               paddingY,
                                                               CGRectGetWidth(bounds) - (paddingX*2),
                                                               20.0)];
        self.timeLabel.font = [UIFont lightFontForSize:10];
        self.timeLabel.textColor = [UIColor mutedColor];
        [headerView addSubview:self.timeLabel];
        [self addSubview:headerView];
        
        // Setup summary text
        self.summaryWebView = [[UIWebView alloc] initWithFrame:CGRectMake(paddingX,
                                                                      CGRectGetMinY(self.timeLabel.frame) + CGRectGetHeight(self.timeLabel.frame) + paddingY*2,
                                                                      CGRectGetWidth(bounds) - (paddingX*2),
                                                                      200.0)];
        self.summaryWebView.backgroundColor = [UIColor clearColor];
        self.summaryWebView.opaque = NO;
        self.summaryWebView.delegate = self;
        self.summaryWebView.scrollView.scrollEnabled = NO;
        self.summaryWebView.scrollView.bounces = NO;
        [self addSubview:self.summaryWebView];
        
        [self sizeToFit];
    }
    return self;
}

- (void)setEntity:(BaseEntity *)entity
{
    _entity = entity;
    self.timeLabel.text = [entity.updatedAt timeAgo];
    [self setText:entity.summary withMentions:entity.mentions];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)defaultsDidChange:(NSNotification *)notification
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // Re-style the summary html.
    NSString *summaryHtml = [self styleSummaryHtml:_summaryTextHtml
                                          fontSize:[prefs floatForKey:@"fontSize"]
                                          fontType:[prefs stringForKey:@"fontType"]
                                          contrast:[prefs boolForKey:@"contrast"]];
    [self.summaryWebView loadHTMLString:summaryHtml baseURL:nil];
}

# pragma mark - HTML/Text setting
- (void)setText:(NSString*)summaryText withMentions:(NSSet*)mentions
{
    // Mentions are sorted by length (longest first) so when replacing them in the summary text,
    // the larger names are captured first. Then names are replaced taking into account their spaces.
    // Combined, this avoids situations with nested `a` tags.
    // For instance, "UN Convention" might become "<a href='#'><a href='#'>UN</a> Convention</a>".
    // Instead, " UN Convention" as a whole is captured: "<a href='#'>UN Convention</a>",
    // and then " UN" can't be captured since it has no space on the left anymore.
    NSArray *sortedMentions = [[mentions allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *first = [NSNumber numberWithInt:[[(Mention*)obj1 name] length]];
        NSNumber *second = [NSNumber numberWithInt:[[(Mention*)obj2 name] length]];
        return [first compare:second];
    }];
    
    for (Mention *mention in sortedMentions) {
        summaryText = [summaryText stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@" %@", mention.name]
                                                             withString:[NSString stringWithFormat:@" <a href='#' onclick='objc(\"%@\");'>%@</a>",
                                                                         mention.concept.conceptId,
                                                                         mention.name]];
    }
    
    NSString *htmlTemplate = [[NSBundle mainBundle] pathForResource:@"SummaryTemplate" ofType:@"html" inDirectory:nil];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlTemplate encoding:NSUTF8StringEncoding error:nil];
    self.summaryTextHtml = [htmlString stringByReplacingOccurrencesOfString:@"{{summary}}" withString:summaryText];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *summaryHtml = [self styleSummaryHtml:self.summaryTextHtml
                                          fontSize:[prefs floatForKey:@"fontSize"]
                                          fontType:[prefs stringForKey:@"fontType"]
                                          contrast:[prefs boolForKey:@"contrast"]];
    [self.summaryWebView loadHTMLString:summaryHtml baseURL:nil];
}


- (NSString*)styleSummaryHtml:(NSString*)html fontSize:(float)size fontType:(NSString*)type contrast:(BOOL)light
{
    if (light) {
        html = [html stringByReplacingOccurrencesOfString:@"{{color}}" withString:@"#000"];
        html = [html stringByReplacingOccurrencesOfString:@"{{link_color}}" withString:@"#237bdc"];
        self.backgroundColor = [UIColor whiteColor];
    } else {
        html = [html stringByReplacingOccurrencesOfString:@"{{color}}" withString:@"#fff"];
        html = [html stringByReplacingOccurrencesOfString:@"{{link_color}}" withString:@"#237bdc"];
        self.backgroundColor = [UIColor colorWithRed:0.09 green:0.102 blue:0.129 alpha:1.0];
    }
    
    html = [html stringByReplacingOccurrencesOfString:@"{{size}}" withString:[NSString stringWithFormat:@"%fem", size]];
    html = [html stringByReplacingOccurrencesOfString:@"{{type}}" withString:type];
    
    return html;
}

# pragma mark - UIView

- (CGSize)sizeThatFits:(CGSize)size
{
    float h = 0;
    float padding = 24.0;
    
    for (UIView *v in [self subviews]) {
        float fh = CGRectGetMinY(v.frame) + CGRectGetHeight(v.frame);
        h = MAX(fh, h);
    }
    return CGSizeMake(CGRectGetWidth(self.frame), h + padding);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Calculate the positioning of subviews.
    float yOffset = NAN;
    for (UIView *v in [self subviews]) {
        CGRect frame = v.frame;
        float oy = frame.origin.y;
        if (isnan(yOffset)) {
            yOffset = oy;
        }
        frame.origin.y = yOffset;
        yOffset += frame.size.height;
        v.frame = frame;
    }
    [self sizeToFit];
    
    // Since this view's size changed,
    // update it's superview's size too.
    [self.superview sizeToFit];
}


# pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    // Resize the UIWebView to fit all content.
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    aWebView.frame = frame;
    
    // Fade in the UIWebView.
    [UIView beginAnimations:@"fade" context:nil];
    aWebView.alpha = 1.0;
    [UIView commitAnimations];
    
    // Disable long touch in the web view.
    [aWebView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none'; document.body.style.KhtmlUserSelect='none'"];
    
    // Resize the summary view.
    [self sizeToFit];
}

// For calling Objective-C from the UIWebView's Javascript.
- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    if ([requestString hasPrefix:@"objc:"]) {
        
        // Extract the selector name from the URL
        NSArray *components = [requestString componentsSeparatedByString:@":"];
        NSString *conceptId = [components objectAtIndex:1];
        
        // Call the given selector
        [self.delegate performSelector:@selector(viewConcept:) withObject:conceptId];
        
        // Cancel the location change
        return NO;
    }
    
    // Accept this location change
    return YES;
}




@end
