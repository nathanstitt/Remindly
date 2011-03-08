//
//  AlarmView.h
//  Created by Nathan Stitt on 11/14/10.
//  Copyright 2011.
//  Distributed under the terms of the GNU General Public License version 3.

// The AlarmViewController handles setting an alarm.
// it has a button which will toggle sliding the view up & down
// calls AlarmViewDelegate to set alarm after save button is pressed


#import <UIKit/UIKit.h>
#import "Note.h"
#import "AlarmQuickTimes.h"
#import "AlarmAbsoluteTimes.h"
#import "AlarmMapView.h"

@class AlarmPopUpController;


@interface AlarmPopUpController : UIViewController {
	AlarmQuickTimes *quickTimes;
	AlarmAbsoluteTimes *absTimes;
	AlarmMapView *mapView;
	BOOL wasSet;
	UISegmentedControl *typeCtrl;
	NSInteger lastTab;
	UITabBar *tabBar;
	Note *currentNote;

    NSMutableArray *panels;
}

-(void)showWithNote:(Note*)note;
-(void)quickSelectionMade;
-(void)absSelectionMade;

@property (nonatomic,readonly ) BOOL wasSet;
@property (nonatomic) BOOL isShowing;

@end
