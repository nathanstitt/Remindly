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
	eraseImg = [UIImage imageNamed:@"erase-icon"];

	button = [ UIButton buttonWithType: UIButtonTypeCustom ];

    [ button setImage: ( v ? drawImg : eraseImg ) forState:UIControlStateNormal ];
	button.frame = CGRectMake(0, 0, drawImg.size.width, drawImg.size.height);

	self = [ super initWithCustomView: button ];
	return self;
}

- (void)dealloc {
	[ button release ];
    [super dealloc];
}

-(BOOL)isErasing {
	return ( [UIImage imageNamed:@"erase-icon"] == [button imageForState:UIControlStateNormal ] );
}

-(void)setIsErasing:(BOOL)v{
	if ( v ){
		[ button setImage: eraseImg forState:UIControlStateNormal ];
	} else {
		[ button setImage: drawImg forState:UIControlStateNormal ];
	}
}

@end
