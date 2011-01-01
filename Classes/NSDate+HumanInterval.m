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

- (NSString *) humanIntervalFromNow {
	NSMutableArray *segments = [ NSMutableArray arrayWithCapacity:1 ];
    int secs = [self timeIntervalSinceNow];

    int delta = secs < 0 ? secs * -1 : secs;
	int remain = delta;
	
	if ( remain > 2 * YEAR) {
		[ segments  addObject: [ NSString stringWithFormat:@"%u years", remain / YEAR ] ];
	} else if ( remain > 1 * YEAR ){
		[ segments addObject: [ NSString stringWithFormat:@"1 year" ] ];
	}
	
	remain -= ( remain / YEAR ) * YEAR;
	
	if ( remain > 2 * MONTH ){
		[ segments  addObject: [ NSString stringWithFormat:@"%u months", remain / MONTH ] ];
	} else if ( remain > 1 * MONTH ){
		[ segments  addObject: [ NSString stringWithFormat:@"1 month"] ];
	}

	remain -= ( remain / MONTH ) * MONTH;
		
	if ( remain > 2 * DAY ){
		[ segments  addObject: [ NSString stringWithFormat:@"%u days", remain / DAY ] ];
	} else if ( remain > 1 * DAY ){
		[ segments  addObject: [ NSString stringWithFormat:@"1 day"] ];
	}
	
	remain -= ( remain / DAY ) * DAY;
	
	if ( delta < MONTH ){
		if ( remain > 2 * HOUR ){
			[ segments  addObject: [ NSString stringWithFormat:@"%u hours", remain / HOUR ] ];
		} else if ( remain > 1 * DAY ){
			[ segments  addObject: [ NSString stringWithFormat:@"1 hour"] ];
		}
	
		remain -= ( remain / HOUR ) * HOUR;

		if ( remain > 2 * MINUTE ){
			[ segments  addObject: [ NSString stringWithFormat:@"%u minutes", remain / MINUTE ] ];
		} else if ( remain > 1 * DAY ){
			[ segments  addObject: [ NSString stringWithFormat:@"1 minute"] ];
		}
	}
	NSString *ret;
	if ( [ segments count ] > 1 ){
		NSString *last = [ segments lastObject ];
		[ segments removeLastObject ];
		ret = [ NSString stringWithFormat:@"%@,%@",
			   [ segments componentsJoinedByString:@"," ],
			   last ];
	} else if ( [ segments count ] ){
		ret = [ segments lastObject ];
	} else {
		ret = @"under a minute";
	}

	if ( delta > DAY*3 ){
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"h:mm a"];
		ret = [ NSString stringWithFormat:@"%@ %@", [formatter stringFromDate:self], ret ]; 
		[ formatter release ];
	}
	
	return [ NSString stringWithFormat:@"%@ %@", ret, 
			secs < 0 ? @"ago" : @"from now" ];
}

@end