//
//  AlarmQuickTImes.m
//  IoGee
//
//  Created by Nathan Stitt on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlarmQuickTImes.h"
#import "AlarmView.h"
#import "Note.h"

@implementation AlarmQuickTimes

@synthesize view=picker,wasSet;

-(id)initWithAlarmView:(AlarmView*)view {
	self = [ super init ];
	alarmView = view;
	picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, 320, 220)];
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
	[ picker selectRow:0 inComponent:0 animated:YES ];
}

-(void)saveToNote:(Note*)note{
	note.alarmName = [ quickChoices objectAtIndex:[ picker selectedRowInComponent:0 ] ];
	note.fireDate  = [ self date ];
}


-(void)setFromNote:(Note*)note{
	if ( note.alarmName ){
		[ picker selectRow:[ quickChoices indexOfObject: note.alarmName	] inComponent:0 animated:NO ];
	}
}


-(NSDate*)date{
	NSNumber *minutes = [ choicesTimes valueForKey: [ quickChoices objectAtIndex: [ picker selectedRowInComponent:0 ] ] ];
	if ( 31 == [ minutes intValue] ){
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
