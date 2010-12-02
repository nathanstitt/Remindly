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
#import "ColorButton.h"
#import "DrawingColorManager.h"

@interface MainViewController : UIViewController <AlarmViewDelegate,DrawingColorManagerDelegate> {
	ScrollController *scroll;
	DrawingColorManager *dcm;
	UIToolbar *mainToolbar;
	UIToolbar *optionsToolbar;
	DrawingViewController *draw;
	UIButton *countBtn;
	AlarmView *alarmView;
	NSArray *toggledButtons;
	NSArray *colorBtns;
	ColorButton *colorBtn;
}

-(void) selectNote:(Note*)note;
-(void) noteWasSelected:(Note*)note;
-(void) updateCount;

@end
