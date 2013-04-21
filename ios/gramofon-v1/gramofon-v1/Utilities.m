//
//  Utilities.m
//  gramofon
//
//  Static library for various utility functions.
//
//  Created by dtrenz on 3/18/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (NSString *)getRelativeTime:(NSString *)origDate
{
    NSString *relativeTime;

    NSDateFormatter *df = [[NSDateFormatter alloc] init];

    // not sure if we need this -dt
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];

    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSTimeZone *tzGMT = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    [df setTimeZone:tzGMT];

    NSDate *convertedDate = [df dateFromString:origDate];
    NSDate *todayDate     = [NSDate date];

    double ti = [convertedDate timeIntervalSinceDate:todayDate];

    ti = ti * -1;

    if ( ti < 1 ) {
    	return @"never";
    } else 	if ( ti < 60 ) {
    	relativeTime = @"less than a minute ago";
    } else if ( ti < 3600 ) {
    	int diff = round( ti / 60 );
    	relativeTime = [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if ( ti < 86400 ) {
    	int diff = round( ti / 60 / 60 );
    	relativeTime =[NSString stringWithFormat:@"%d hours ago", diff];
    } else if ( ti < 2629743 ) {
    	int diff = round( ti / 60 / 60 / 24 );
    	relativeTime =[NSString stringWithFormat:@"%d days ago", diff];
    } else {
    	relativeTime = @"never";
    }

    return relativeTime;
}

@end
