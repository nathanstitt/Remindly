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

-(void)setEntering:(BOOL)v{
	entering = v;
}
- (NSString *)title {
	return entering ? @"Entering" : @"Exiting";
}

// optional

@end

