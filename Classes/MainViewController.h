//
//  Created by Nathan Stitt on 11/10/10
//  Copyright 2011.
//  Distributed under the terms of the GNU General Public License version 3.

// As the name says, this is the MainViewController.
// It is responsible for laying out the toolbar,
// DrawingController and NoteSelector
// and then handling the interactions between them.

// FIXME - move the toolbar into
// it's own class and have it be responsible for
// calling actions, which would neaten this up quite a bit

#import <UIKit/UIKit.h>
#import "AlarmViewController.h"
#import "ColorButton.h"
#import "DrawingColorController.h"
#import "CountingButton.h"
#import "DrawEraseButton.h"

@class DrawingViewController, NoteSelectorController;

@interface MainViewController : UIViewController <UIAlertViewDelegate,
												  DrawingColorManagerDelegate> {
	NoteSelectorController *scroll;
	DrawingColorController *dcm;
	UIToolbar *mainToolbar;
	UIToolbar *optionsToolbar;
	DrawingViewController *draw;
	CountingButton *countBtn;
	AlarmViewController *alarmView;
	NSArray *toggledButtons;
	NSArray *colorBtns;
	ColorButton *colorBtn;
	DrawEraseButton *eraseBtn;
}

// select the given note 
// called by:
//      AppDelegate when a notification fires
//      NoteSelectorController when a note's selected
-(void) selectNote:(Note*)note;

@end
