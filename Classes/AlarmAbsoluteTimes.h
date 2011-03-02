//
//  AlarmAbsoluteTimes.h
//  Created by Nathan Stitt on 11/14/10.
//  Copyright 2011.
//  Distributed under the terms of the GNU General Public License version 3.

// The AlarmAbsoluteTimes is a UIDatePicker which
// allows setting the alarm to an arbitrary date/time

#import <UIKit/UIKit.h>

@class Note,AlarmPopUpView;

@interface AlarmAbsoluteTimes : NSObject {
	UIDatePicker *picker;
}

-(id)initWithAlarmView:(AlarmPopUpView*)view;
-(void)reset;
-(void)saveToNote:(Note*)note;

@property (readonly,nonatomic) UIView *view;
@property (nonatomic,assign) NSDate *date;

@property (nonatomic,readonly ) BOOL wasSet;
@end
