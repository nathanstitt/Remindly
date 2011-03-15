//
//  MainToolBar.h
//  Remindly
//
//  Created by Nathan Stitt on 1/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColorButton.h"
#import "CountingButton.h"
#import "ToggleButton.h"

@class MainViewController,DrawingPaletteController;

@interface MainToolBar : UIToolbar {

	MainViewController *mvc;

	NSArray *drawButtons;
	NSArray *selButtons;
	ToggleButton    *eraseBtn;
	UIBarButtonItem *pickerBtn;
	CountingButton *countBtn;

}


-(void) setDrawingMode:(BOOL)draw;

-(id)initWithController:(MainViewController*)m;

@end
