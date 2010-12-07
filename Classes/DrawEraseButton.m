//
//  EraseButton.m
//  Mr Naggles
//
//  Created by Nathan Stitt on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DrawEraseButton.h"

@implementation DrawEraseButton

@synthesize button;

-(id)initWithDrawingState:(BOOL)v {
	drawImg  = [UIImage imageNamed:@"draw-icon"];
	[ drawImg retain ];
	eraseImg = [UIImage imageNamed:@"erase-icon"];
	[eraseImg retain ];
	button = [ UIButton buttonWithType: UIButtonTypeCustom ];
	[ button retain ];
    [ button setImage: ( v ? eraseImg : drawImg ) forState:UIControlStateNormal ];
	button.frame = CGRectMake(0, 0, eraseImg.size.width, eraseImg.size.height);

	self = [ super initWithCustomView: button ];
	return self;
}

- (void)dealloc {
	[ button release ];
	[ drawImg release ];
	[ eraseImg release ];
    [super dealloc];
}

-(BOOL)isErasing {
	return ( drawImg == [ button imageForState:UIControlStateNormal ] );
}

-(void)setIsErasing:(BOOL)v{
	if ( v ){
		[ button setImage: drawImg forState:UIControlStateNormal ];
	} else {
		[ button setImage: eraseImg forState:UIControlStateNormal ];
	}
}

@end
