//
//  AlarmQuickTimes.h
//  Created by Nathan Stitt on 11/18/10.
//  Copyright 2011.
//  Distributed under the terms of the GNU General Public License version 3.

// The AlarmQuickTimes view holds a UIPicker which contains
// shortcut times such as 3 minutes, 10 minutes, half hour, etc.
// it's populated from the alarm_times.plist file

#import <Foundation/Foundation.h>

@class AlarmPopUpController,Note;

@interface AlarmQuickTimes : NSObject <UIPickerViewDelegate,UIPickerViewDataSource> {
	UIPickerView *picker;
	AlarmPopUpController *alarmView;
	NSDictionary *choicesTimes;
	NSArray *quickChoices;
}

-(id)initWithAlarmView:(AlarmPopUpController*)view frame:(CGRect)frame;
-(void)setFromNote:(Note*)note;
-(void)saveToNote:(Note*)note;
-(NSDate*)date;
-(void)reset;
-(BOOL)hasDateType:(NSString*)name;


@property (readonly,nonatomic) UIView *view;
-(void)selectBlank;
-(BOOL)isSet;

@end
