//
//  NSDate+DateUtils.m
//  Argos
//
//  Created by Francis Tseng on 2/17/14.
//  Copyright (c) 2014 Argos. All rights reserved.
//

#import "NSDate+DateUtils.h"

@implementation NSDate (DateUtils)

+(NSString *)dateDiff:(NSDate *)origDate {
    // Based off of:
    // https://stackoverflow.com/a/932130/1097920
    NSDate *todayDate = [NSDate date];
    double ti = [origDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
    	return @"never";
    } else 	if (ti < 60) {
    	return @"less than a minute ago";
    } else if (ti < 3600) {
    	int diff = round(ti / 60);
    	return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (ti < 86400) {
    	int diff = round(ti / 60 / 60);
    	return [NSString stringWithFormat:@"%d hours ago", diff];
    } else if (ti < 2629743) {
    	int diff = round(ti / 60 / 60 / 24);
    	return [NSString stringWithFormat:@"%d days ago", diff];
    } else if (ti < 31536000) {
        int diff = round(ti / 60 / 60 / 24 / 30);
        return [NSString stringWithFormat:@"%d months ago", diff];
    } else {
        int diff = round(ti / 60 / 60 / 24 / 365);
        return[NSString stringWithFormat:@"%d years ago", diff];
    }
}

@end
