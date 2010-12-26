//
//  UIColor+FromToRGB.m
//  Mr Naggles
//
//  Created by Nathan Stitt on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIColor+FromToRGB.h"


@implementation UIColor(FromToRGB)


+(UIColor*)UIColorFromRGBUInt:(NSUInteger)rgb {
	int r = (rgb >> 16) & 0xFF;
	int g = (rgb >> 8) & 0xFF;
	int b = (rgb) & 0xFF;

	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:1.0f];
}

-(NSInteger)toRGBUInt{
	const CGFloat *c = CGColorGetComponents( [ self CGColor ] );
	return (((unsigned int)roundf(c[0] * 255)) << 16)
	     | (((unsigned int)roundf(c[1] * 255)) << 8)
	     | (((unsigned int)roundf(c[2] * 255)));

}

@end
