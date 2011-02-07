//
//  ColorButton.h
//  Created by Nathan Stitt on 11/30/10.
//  Copyright 2011.
//  Distributed under the terms of the GNU General Public License version 3.
// 
//  A UIButton with a rounded center set to a given color

#import <UIKit/UIKit.h>


@interface ColorButton : UIButton {
	UIColor *color;
}

- (id)initWithColor:(UIColor*)c;

@property (retain,nonatomic) UIColor *color;

@end
