//
//  DrawEraseButton.m
/*  This file is part of Remindly.

    Remindly is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3.

    Remindly is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Remindly.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "DrawEraseButton.h"

@implementation DrawEraseButton

@synthesize button;

-(id)initWithDrawingState:(BOOL)v {
	drawImg  = [UIImage imageNamed:@"draw_icon"];
	[ drawImg retain ];
	eraseImg = [UIImage imageNamed:@"erase_icon"];
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
