//
//  MainToolBar.h
//  Remindly
//
//  Created by Nathan Stitt on 1/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColorButton.h"
#import "DrawingColorController.h"
#import "CountingButton.h"
#import "DrawEraseButton.h"

@class MainViewController;

@interface MainToolBar : UIToolbar <DrawingColorManagerDelegate> {

	MainViewController *mvc;

	NSArray *drawButtons;
	NSArray *selButtons;
	NSArray *colorButtons;
	
	DrawingColorController *dcm;

	ColorButton *colorBtn;
	DrawEraseButton *eraseBtn;
	UIBarButtonItem *pickerBtn;
	CountingButton *countBtn;

}


-(void) setDrawingMode:(BOOL)draw;

-(id)initWithController:(MainViewController*)m;

@end
