//
//  EraseButton.h
//  Mr Naggles
//
//  Created by Nathan Stitt on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EraseButton : UIBarButtonItem {
	UIButton *button;
	UIImage *drawImg;
	UIImage *eraseImg;
	
}

-(id)initWithDrawingState:(BOOL)drawing;

@property (nonatomic,readonly) UIButton *button;
@property (nonatomic,assign) BOOL isErasing;

@end
