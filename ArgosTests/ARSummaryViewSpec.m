//
//  ARSummaryViewSpec.m
//  Argos
//
//  Created by Francis Tseng on 3/2/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "Kiwi.h"
#import "ARSummaryView.h"
#import "Entity.h"

SPEC_BEGIN(ARSummaryViewSpec)

describe(@"ARSummaryView", ^{
    __block ARSummaryView* summaryView;
    
    beforeEach(^{
        CGRect screenRect = [UIScreen mainScreen].bounds;
        summaryView = [[ARSummaryView alloc] initWithFrame:screenRect];
    });
    
    afterEach(^{
        summaryView = nil;
    });
    
    it(@"sets html for entities", ^{
        NSString* summary = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco John Kerry laboris nisi ut aliquip ex ea commodo consequat.";
        NSString* expectedHtml = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco <a href='#' onclick='objc(\"john-kerry\");'>John Kerry</a> laboris nisi ut aliquip ex ea commodo consequat.";
        
        // For some  reason this causes a "mock received unexpected message -setName:" error,
        // but provides no information on where it is or why it's happening, because I am not calling
        // any such method anywhere.
        summaryView.summaryWebView = [UIWebView mock];
        [[[summaryView.summaryWebView should] receive] loadHTMLString:expectedHtml baseURL:nil];
        
        // Mock entity
        Entity* entity = [Entity mock];
        entity.name = @"John Kerry";
        entity.entityId = @"john-kerry";
        
        NSSet *entities = [NSSet setWithObject:entity];
        
        [summaryView setText:summary withEntities:entities];
        
    });
});

SPEC_END

