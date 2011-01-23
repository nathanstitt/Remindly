//
//  DrawingColorController.h
//  Created by Nathan Stitt on 12/1/10.
//  Copyright 2011.
//  Distributed under the terms of the GNU General Public License version 3.
//
//  Has a ColorButton, and a hidden toolbar which allows setting
//  the selected drawing color
//  after a selection is made, sets the UIButton to that color
//  and alerts the delegate

#import <Foundation/Foundation.h>

@class DrawingColorController;

@protocol DrawingColorManagerDelegate
@required
-(void)drawingColorManagerColorUpdated:(DrawingColorController*)manager color:(CGColorRef)color;
@end
 

@class MainViewController,ColorButton;

@interface DrawingColorController : NSObject {
	UIBarButtonItem *pickerButton;
	UIToolbar *toolBar;
	id<DrawingColorManagerDelegate> delegate;
	MainViewController *mvc;
}

// stores the last color used in a plist
// on startup, select that color again
-(id)initWithLastColor;

// the currently selected color
@property (nonatomic, retain) UIColor *selectedColor;
@property (nonatomic, assign ) id<DrawingColorManagerDelegate> delegate;

// these are exposed so the MainViewController can add them to 
// the appropriate views
@property (nonatomic, readonly) UIBarButtonItem *pickerButton;
@property (nonatomic, readonly) UIToolbar *toolBar;

@end
