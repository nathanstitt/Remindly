//
//  AlarmAbsoluteTimes.m
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

#import "AlarmAbsoluteTimes.h"
#import "AlarmViewController.h"
#import "Note.h"

@implementation AlarmAbsoluteTimes

@synthesize view=picker;

-(id)initWithAlarmView:(AlarmViewController*)view {
	self = [ super init ];
	if ( ! self ){
		return nil;
	}
	picker = [[ UIDatePicker alloc ] initWithFrame:view.childFrame ];
	return self;
}

-(void)reset {
	picker.date = [ NSDate date ];
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
	[ note setAlarmType:[ formmatter stringFromDate: self.date ]  ];
}

@end
