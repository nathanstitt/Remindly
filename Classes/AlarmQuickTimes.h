//
//  AlarmQuickTImes.h
//  IoGee
//
//  Created by Nathan Stitt on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AlarmView,Note;

@interface AlarmQuickTimes : NSObject <UIPickerViewDelegate,UIPickerViewDataSource> {
	UIPickerView *picker;
	BOOL wasSet;
	AlarmView *alarmView;
	NSDictionary *choicesTimes;
	NSArray *quickChoices;
}

-(id)initWithAlarmView:(AlarmView*)view;
-(void)setFromNote:(Note*)note;
-(void)saveToNote:(Note*)note;

@property (readonly,nonatomic) UIView *view;
@property (nonatomic,readonly ) BOOL wasSet;

@end
