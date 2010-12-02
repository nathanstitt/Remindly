//
//  ColorButton.h
//  Mr Naggles
//
//  Created by Nathan Stitt on 11/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ColorButton : UIButton {
	CGColorRef color;
	UIView *view;
}

- (id)iniWithColor:(CGColorRef)c;

@property (nonatomic) CGColorRef color;

@end
