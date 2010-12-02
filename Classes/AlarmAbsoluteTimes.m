//
//  AlarmAbsoluteTimes.m
//  Mr Naggles
//
//  Created by Nathan Stitt on 12/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlarmAbsoluteTimes.h"


@implementation AlarmAbsoluteTimes

@synthesize view=picker;

- (id)init {
	self = [ super init ];
	
	picker = [[ UIDatePicker alloc ] initWithFrame:CGRectMake(0, 30, 320, 220) ];
	return self;
}

-(NSDate*)date{
	return picker.date;
}

-(void)setDate:(NSDate*)date{
	picker.date = date;
}

- (void)dealloc {
    [super dealloc];
}


@end
