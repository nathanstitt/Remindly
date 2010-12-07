//
//  UIColor+FromToRGB.h
//  Mr Naggles
//
//  Created by Nathan Stitt on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIColor(FromToRGB) 

+(UIColor*)UIColorFromRGBInt:(NSUInteger)rgb;
-(NSUInteger)toRGBInt;

@end
