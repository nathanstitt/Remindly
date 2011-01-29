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
#import "MainToolBar.h"

@class DrawingViewController, NoteSelectorController;

@interface MainViewController : UIViewController <UIAlertViewDelegate> {
	NoteSelectorController *selector;
	MainToolBar *toolbar;
	DrawingViewController *drawing;
	AlarmViewController *alarm;
}

-(void) toggleDrawingMode;
-(void) selectNote:(Note*)note;

@property (nonatomic) BOOL drawingMode;

@property (readonly,nonatomic) DrawingViewController  *drawing;
@property (readonly,nonatomic) AlarmViewController    *alarm;
@property (readonly,nonatomic) NoteSelectorController *selector;



@end
