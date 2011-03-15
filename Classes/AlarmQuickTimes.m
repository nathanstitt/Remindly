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
#import "AlarmPopUpController.h"
#import "Note.h"

@implementation AlarmQuickTimes

@synthesize view=picker;

-(id)initWithAlarmView:(AlarmPopUpController*)view frame:(CGRect)frame {
	self = [ super init ];
	if ( ! self ){
		return nil;
	}

	alarmView = view;
	picker = [[UIPickerView alloc] initWithFrame: frame ];
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
	picker.dataSource = self;

	NSString *plist = [ [[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"alarm_times.plist"];
	choicesTimes = [ [ NSMutableDictionary alloc] initWithContentsOfFile: plist ];
	[ choicesTimes retain ];
	quickChoices = [ choicesTimes keysSortedByValueUsingSelector:@selector(compare:)];
	[ quickChoices retain ];

    picker.showsSelectionIndicator = NO;
    
    //Resize the picker, rotate it so that it is horizontal and set its position
	CGAffineTransform rotate = CGAffineTransformMakeRotation(-3.14/2);     //horizontal angle -pi/2
	rotate = CGAffineTransformScale(rotate, 1, 1.50);
	CGAffineTransform t0 = CGAffineTransformMakeTranslation(1, -40.5);// (x,y) position
	picker.transform = CGAffineTransformConcat(rotate,t0);
	

	return self;
}

-(void)selectBlank {
    [ picker selectRow:0 inComponent:0 animated:YES ];
}

- (BOOL) isSet {
    return ( [ picker selectedRowInComponent:0 ] > 0 );
}

-(void)reset {
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
    NSInteger selIndex = [ picker selectedRowInComponent:0 ];
    NSLog(@"getDate - index: %i", selIndex );
    if ( ! selIndex ){
        selIndex = 1;
    }
	NSNumber *minutes = [ choicesTimes valueForKey: [ quickChoices objectAtIndex: selIndex] ];
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

-(UIView *) pickerView:(UIPickerView *)pickerView 
			viewForRow:(NSInteger) row
          forComponent:(NSInteger)component 
           reusingView:(UIView *)view {
    
	UILabel *label;

//[ UIFont systemFontOfSize: 17 ];
	label = [[UILabel alloc] initWithFrame:CGRectZero];
	label.text = [ self pickerView:pickerView titleForRow:row forComponent:component];

    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor blackColor];
	label.textAlignment = UITextAlignmentCenter;
	label.font = [UIFont fontWithName:@"AppleGothic" size:17.0];;

	label.frame = CGRectMake(0, 0, 45, 60 );
//							 [ self pickerView:pickerView widthForComponent:component], 
//							 [ self pickerView:pickerView widthForComponent:component]);
	label.backgroundColor = [UIColor clearColor];
	label.opaque = YES;
	
	label.transform = CGAffineTransformRotate(label.transform, M_PI/2 );
	return [ label autorelease ];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 80;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ( 0 == row ){
        [ pickerView selectRow:1 inComponent:0 animated:YES ];
    }
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
