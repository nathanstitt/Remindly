//
//  MainViewController.h
//  IoGee
//
//  Created by Nathan Stitt on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingViewController.h"
#import "ScrollController.h"
#import "AlarmView.h"

@interface MainViewController : UIViewController <AlarmViewDelegate> {
	ScrollController *scroll;
	UIToolbar *mainToolbar;
	UIToolbar *optionsToolbar;
	DrawingViewController *draw;
	UIButton *countBtn;
	UIBarButtonItem *alarmBtn;
	AlarmView *alarmView;
	NSArray *toggledButtons;
}

-(void) selectNote:(Note*)note;
-(void) noteWasSelected:(Note*)note;
-(void) updateCount;

@end
