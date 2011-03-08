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
#import "AlarmPopUpController.h"
#import "MainToolBar.h"

@class DrawingViewController, NoteSelectorController, DrawingPaletteController;

@interface MainViewController : UIViewController <UIAlertViewDelegate> {
	NoteSelectorController *selector;
	MainToolBar *toolbar;

    DrawingPaletteController *drawTools;
	DrawingViewController *drawing;
	AlarmPopUpController *alarm;
}

-(void) toggleDrawingMode;
-(void) selectNote:(Note*)note;

@property (nonatomic) BOOL isAlarmShowing;
@property (nonatomic) BOOL isDrawToolsShowing;
@property (nonatomic) BOOL drawingMode;
@property (readonly,nonatomic) DrawingPaletteController     *drawTools;
@property (readonly,nonatomic) DrawingViewController  *drawing;
@property (readonly,nonatomic) AlarmPopUpController         *alarm;
@property (readonly,nonatomic) NoteSelectorController *selector;



@end
