//
//  EraseButton.h
//  Created by Nathan Stitt on 12/4/10.
//  Copyright 2011.
//  Distributed under the terms of the GNU General Public License version 3.

// a simple UIButton that toggles between a Pencil icon and an eraser

// FIXME, why not generalize this out to just two generic UImage's?

#import <Foundation/Foundation.h>


@interface DrawEraseButton : UIBarButtonItem {
	UIButton *button;
	UIImage *drawImg;
	UIImage *eraseImg;
}

-(id)initWithDrawingState:(BOOL)drawing;

@property (nonatomic,readonly) UIButton *button;
@property (nonatomic,assign) BOOL isErasing;

@end
