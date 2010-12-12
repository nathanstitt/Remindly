//
//  AlarmAbsoluteTimes.m
//  Mr Naggles
//
//  Created by Nathan Stitt on 12/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlarmAbsoluteTimes.h"
#import "Note.h"

@implementation AlarmAbsoluteTimes

@synthesize view=picker;

- (id)init {
	self = [ super init ];
	picker = [[ UIDatePicker alloc ] initWithFrame:CGRectMake(0, 30, 320, 220) ];
	return self;
}

-(void)reset {
	picker.date = [ NSDate date ];
	picker.minimumDate = picker.date;
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

-(void)saveToNote:(Note*)note{
	static NSDateFormatter *formmatter;
	if ( ! formmatter ){
		formmatter = [[NSDateFormatter alloc] init];
        [ formmatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [ formmatter setDateFormat:@"hh:mm a EEE, MMM dd, YYYY" ];
	}
	[ note setFireDate: self.date ];
	[ note setAlarmName:[ formmatter stringFromDate: self.date ]  ];
}

@end
