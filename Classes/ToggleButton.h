//
//  EraseButton.h
//  Created by Nathan Stitt on 12/4/10.
//  Copyright 2011.
//  Distributed under the terms of the GNU General Public License version 3.

// a simple UIButton that toggles between an array of images when pressed


#import <Foundation/Foundation.h>


@interface ToggleButton : UIButton {
	NSArray *choices;
	BOOL toggleOnTouch;
}

-(id)initWithImages:(NSArray*)images Frame:(CGRect)frame;

// advance to next image
-(void)toggle;

// the currently selected image's index
@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic) BOOL toggleOnTouch;

// anything other than the first image returns true
@property (nonatomic) BOOL boolValue;



@end
