//
//  AlarmAnnotation.m
//  Remindly
//
//  Created by Nathan Stitt on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlarmAnnotation.h"


@implementation AlarmAnnotation

@synthesize coordinate,entering;

-init {
	self = [super init];
	if ( ! self ){
		return nil;
	}
	entering = YES;
	coordinate.latitude = 37.810000;
	coordinate.longitude = -122.477989;
    return self;
	
}

- (NSString *)title
{
	if ( self.entering ){
		return @"When Entering";
	} else {
		return @"When Leaving";
	}
}

// optional
- (NSString *)subtitle
{
    return @"Quick Tap to Change";
}

@end

