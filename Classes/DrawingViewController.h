//
//  DrawingViewController.h
//  Created by Nathan Stitt on 11/10/10
//  Copyright 2011.
//  Distributed under the terms of the GNU General Public License version 3.

// Tracks touches on a view and draws lines between
// them using bezier curves

#import <UIKit/UIKit.h>
#import "GradientButton.h"
#import "DrawingTextBox.h"

@class MainViewController,AlarmTitleButton,Note;

#define DRAWING_BEGAN_NOTIFICATION @"DrawingBeganNotification"

@interface DrawingViewController : UIViewController {
	CGPoint lastPoint;
	CGPoint points[4];
	MainViewController *mainView;
	UIImageView *drawImage;
	Note *note;
	BOOL isErasing;
	BOOL wasMoved;
	AlarmTitleButton *alarmTitle;
	DrawingTextBox *currentTextEditBox;
	UIColor *color;
}

// keep a pointer to the mainview 
- (id)initWithMainView:(MainViewController*)mv;

// erase image
- (void)clear;

// are we hidden
@property (nonatomic) BOOL hidden;

// the current color
@property (retain,nonatomic) UIColor *color;

// how thick the line should be
@property (nonatomic) CGFloat lineWidth;

// which note we're working from
@property (nonatomic,retain) Note* note;

// is the erasing tool active
@property (nonatomic) BOOL isErasing;

// expose this so MainView can hang actions on it
@property (nonatomic,readonly) AlarmTitleButton *alarmTitle;

// add a text bubble
-(void) addText;

// remove a text bubble
-(void) removeText:(DrawingTextBox*)ntb;

@end
