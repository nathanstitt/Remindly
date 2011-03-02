//
//  AlarmQuickTImes.m
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


#import "AlarmQuickTImes.h"
#import "AlarmPopUpView.h"
#import "Note.h"

@implementation AlarmQuickTimes

@synthesize view=picker,wasSet;

-(id)initWithAlarmView:(AlarmPopUpView*)view {
	self = [ super init ];
	if ( ! self ){
		return nil;
	}

	alarmView = view;
	picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0.0, 20.0, 320.0, 90.0) ];
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
	picker.dataSource = self;

	NSString *plist = [ [[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"alarm_times.plist"];
	choicesTimes = [ [ NSMutableDictionary alloc] initWithContentsOfFile: plist ];
	[ choicesTimes retain ];
	quickChoices = [ choicesTimes keysSortedByValueUsingSelector:@selector(compare:)];
	[ quickChoices retain ];

	return self;
}

-(void)reset {
    wasSet = NO;
	[ picker selectRow:4 inComponent:0 animated:YES ];
}

-(void)saveToNote:(Note*)note{
	note.alarmType = [ quickChoices objectAtIndex:[ picker selectedRowInComponent:0 ] ];
    note.alarmTag = 0;
	note.fireDate  = [ self date ];
}


-(void)setFromNote:(Note*)note{
	if ( note.alarmType ){
		[ picker selectRow:[ quickChoices indexOfObject: note.alarmType	] inComponent:0 animated:NO ];
	}
}


-(BOOL)hasDateType:(NSString*)name{
	NSInteger indx = [ quickChoices indexOfObject: name ];
	return (  NSNotFound != indx );
}


-(NSDate*)date{
	NSNumber *minutes = [ choicesTimes valueForKey: [ quickChoices objectAtIndex: [ picker selectedRowInComponent:0 ] ] ];
	if ( 51 == [ minutes intValue] ){
		NSDate *now = [ NSDate date ];
		NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:now];
		return [ now dateByAddingTimeInterval: (( 60 -  [components minute] )*60) ];
	} else if ( ! [ minutes boolValue ] ){
		return NULL;
	} else {
		return [ NSDate dateWithTimeIntervalSinceNow: [ minutes intValue ] * 60 ];
	}
}


- (void)dealloc {
	[ picker release ];
	[ super dealloc  ];
}

#pragma mark PickerViewController delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	wasSet = YES;
	[ alarmView quickSelectionMade ];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
        return 1;
}


- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
        return [ quickChoices count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	id val = [ quickChoices objectAtIndex:row ];
	return val;
}


@end
