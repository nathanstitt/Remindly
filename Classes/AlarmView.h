//
//  AlarmView.h
//  IoGee
//
//  Created by Nathan Stitt on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "AlarmQuickTimes.h"
#import "AlarmAbsoluteTimes.h"

@class AlarmView;

@protocol AlarmViewDelegate
@required
-(void)alarmSet:(AlarmView*)av;
-(void)alarmShowingChanged:(AlarmView*)av;
@end


@interface AlarmView : UIView {
	BOOL wasSet;
	id<AlarmViewDelegate> delegate;
	NSArray *panels;
	NSArray *quickChoices;
	NSDictionary *choicesTimes;
	AlarmQuickTimes *quickTimes;
	AlarmAbsoluteTimes *absTimes;
	UISegmentedControl *typeCtrl;
}

-(void)showWithNote:(Note*)note;

-(void)saveToNote:(Note*)note;

-(void)quickSelectionMade;

@property (nonatomic, assign) id<AlarmViewDelegate> delegate;
@property (nonatomic,readonly ) BOOL wasSet;
@property (nonatomic) BOOL isShowing;

@end
