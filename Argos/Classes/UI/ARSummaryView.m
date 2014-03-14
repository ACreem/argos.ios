//
//  ARSummaryView.m
//  Argos
//
//  Created by Francis Tseng on 2/8/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "ARSummaryView.h"
#import "Entity.h"
#import "Mention.h"

@interface ARSummaryView ()
// Keep track of the summary html,
// which includes the processed summary text but
// does NOT include filled in styling values.
// This way we can update them as necessary when font preferences change.
@property (nonatomic, strong) NSString *summaryTextHtml;
@end

@implementation ARSummaryView

- (instancetype)initWithOrigin:(CGPoint)origin text:(NSString*)summaryText updatedAt:(NSDate*)updatedAt
{
    CGFloat paddingX = 16.0;
    CGFloat paddingY = 8.0;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(origin.x, origin.y, CGRectGetWidth(bounds), 400.0); // Arbirtary height, it is set programatically later.
    self = [super initWithFrame:frame];
    if (self) {
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
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingX,
                                                               paddingY,
                                                               CGRectGetWidth(bounds) - (paddingX*2),
                                                               20.0)];
        _timeLabel.text = [updatedAt timeAgo];
        _timeLabel.font = [UIFont lightFontForSize:10];
        _timeLabel.textColor = [UIColor mutedColor];
        [headerView addSubview:_timeLabel];
        [self addSubview:headerView];
        
        // Setup summary text
        _summaryWebView = [[UIWebView alloc] initWithFrame:CGRectMake(paddingX,
                                                                      CGRectGetMinY(_timeLabel.frame) + CGRectGetHeight(_timeLabel.frame) + paddingY*2,
                                                                      CGRectGetWidth(bounds) - (paddingX*2),
                                                                      200.0)];
        _summaryWebView.backgroundColor = [UIColor clearColor];
        _summaryWebView.opaque = NO;
        _summaryWebView.delegate = self;
        _summaryWebView.scrollView.scrollEnabled = NO;
        _summaryWebView.scrollView.bounces = NO;
        [self setText:summaryText withMentions:nil];
        [self addSubview:_summaryWebView];
        
        [self sizeToFit];
    }
    return self;
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
    [_summaryWebView loadHTMLString:summaryHtml baseURL:nil];
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
                                                             withString:[NSString stringWithFormat:@" <a href='#' onclick='objc(\"%@\");'>%@</a>", mention.parent.entityId, mention.name]];
    }
    
    NSString *htmlTemplate = [[NSBundle mainBundle] pathForResource:@"SummaryTemplate" ofType:@"html" inDirectory:nil];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlTemplate encoding:NSUTF8StringEncoding error:nil];
    _summaryTextHtml = [htmlString stringByReplacingOccurrencesOfString:@"{{summary}}" withString:summaryText];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *summaryHtml = [self styleSummaryHtml:_summaryTextHtml
                                          fontSize:[prefs floatForKey:@"fontSize"]
                                          fontType:[prefs stringForKey:@"fontType"]
                                          contrast:[prefs boolForKey:@"contrast"]];
    [_summaryWebView loadHTMLString:summaryHtml baseURL:nil];
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
    //float w = 0;
    float h = 0;
    float padding = 24.0;
    
    for (UIView *v in [self subviews]) {
        //float fw = v.frame.origin.x + v.frame.size.width;
        float fh = CGRectGetMinY(v.frame) + CGRectGetHeight(v.frame);
        //w = MAX(fw, w);
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
        NSString *entityId = [components objectAtIndex:1];
        
        // Call the given selector
        [_delegate performSelector:@selector(viewEntity:) withObject:entityId];
        
        // Cancel the location change
        return NO;
    }
    
    // Accept this location change
    return YES;
}




@end
