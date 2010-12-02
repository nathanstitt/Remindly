//
//  NSDate+HumanInterval.m
//  Buzzalot
//
//  Created by David E. Wheeler on 2/18/10.
//  Copyright 2010 Kineticode, Inc.. All rights reserved.
//

#import "NSDate+HumanInterval.h"

#define SECOND     1
#define MINUTE (  60 * SECOND )
#define HOUR   (  60 * MINUTE )
#define DAY    (  24 * HOUR   )
#define WEEK   (   7 * DAY    )
#define MONTH  (  30 * DAY    )
#define YEAR   ( 365 * DAY    )

@implementation NSDate (HumanInterval)

- (NSString *) humanIntervalSinceNow {
	NSString *ret;
    int secs = [self timeIntervalSinceNow];
    int delta = secs < 0 ? secs * -1 : secs;
    if (delta <= 30 * SECOND) {
        ret = NSLocalizedString(@"a few secs", nil);
    } else if (delta < 2 * MINUTE ) {
        ret = @"around a minute";
    } else if (delta <= 45 * MINUTE) {
        ret = [NSString stringWithFormat:@"%u mins", delta / MINUTE];
    } else if (delta <= 90 * MINUTE) {
        ret = @"1 hour";
    } else if (delta < 3 * HOUR) {
        ret = @"2 hours";
    } else if (delta < 23 * HOUR) {
        ret = [NSString stringWithFormat:@"%u hours", delta / HOUR];
    } else if (delta < 36 * HOUR) {
        ret = @"1 day";
    } else if (delta < 72 * HOUR) {
        ret = @"2 days";
    } else if (delta < 7 * DAY) {
        ret = [NSString stringWithFormat:@"%u days", delta / DAY];
    } else if (delta < 11 * DAY) {
        ret = @"1 week";
    } else if (delta < 14 * DAY) {
        ret = @"2 weeks";
    } else if (delta < 9 * WEEK) {
        ret = [NSString stringWithFormat:@"%u weeks", delta / WEEK];
    } else if (delta < 19 * MONTH) {
        ret = [NSString stringWithFormat:@"%u months", delta / MONTH];        
    } else if (delta < 2 * YEAR) {
        ret = @"1 year";
    } else {
        ret = [NSString stringWithFormat:@"%u years", delta / YEAR];        
    }
	return [ NSString stringWithFormat:@"%@ %@", ret, 
			secs < 0 ? @"ago" : @"from now" ];
}

@end