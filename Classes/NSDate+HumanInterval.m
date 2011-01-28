//
//  NSDate+HumanInterval.m
/*  This file is part of Remindly.

    Remindly is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3.

    Remindly is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Remindly.  If not, see <http://www.gnu.org/licenses/>.
*/

// The HumanInterval category adds a single method to 
// NSDate: humanIntervalFromNow
// this method returns an english string listing the date interval
// in an easy to read manner.

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
		} else if ( remain > 1 * HOUR ){
			[ segments  addObject: [ NSString stringWithFormat:@"1 hour"] ];
		}

		remain -= ( remain / HOUR ) * HOUR;

		if ( remain > 2 * MINUTE ){	
			[ segments  addObject: [ NSString stringWithFormat:@"%u minutes", remain / MINUTE ] ];
		} else if ( remain > 1 * MINUTE ) {
			[ segments  addObject: [ NSString stringWithFormat:@"1 minute"] ];
		}
	
		if ( delta < 10 * MINUTE ){
			remain -= ( remain / MINUTE ) * MINUTE;
			if ( remain ){
				[ segments  addObject: [ NSString stringWithFormat:@"%u seconds", remain ] ];
			}
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
		ret = @"a few seconds";
	}

	if ( delta > MONTH ){
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"h:mm a"];
		ret = [ NSString stringWithFormat:@"%@ %@", [formatter stringFromDate:self], ret ]; 
		[ formatter release ];
	}
	
	return [ NSString stringWithFormat:@"%@ %@", ret, 
			secs < 0 ? @"ago" : @"from now" ];
}

@end