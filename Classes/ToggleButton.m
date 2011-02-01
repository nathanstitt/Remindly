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

#import "ToggleButton.h"

@implementation ToggleButton

@synthesize toggleOnTouch;

-(id)initWithImages:(NSArray*)images Frame:(CGRect)frame{
	self = [ super initWithFrame: frame ];
	if ( ! self ){ 
		return nil;
	}
	choices = images;
	[ choices retain ];
	self.selectedIndex = 0;
	[ self setToggleOnTouch:YES ];

	return self;
}

-(void)setToggleOnTouch:(BOOL)v {
	if ( v != toggleOnTouch ){
		if ( v ){
			[ self addTarget:self action:@selector(moveNext:) forControlEvents:UIControlEventTouchUpInside];
		} else {
			[ self removeTarget:self action:@selector(moveNext:) forControlEvents:UIControlEventTouchUpInside ];
		}
	}
	toggleOnTouch = v;
}


-(void)moveNext:(id)sel {
	[ self toggle ];
}


-(NSInteger)selectedIndex {
	return [ choices indexOfObject: [ self imageForState: UIControlStateNormal ] ];
}


-(void) setSelectedIndex:(NSInteger)index {
	[ self setImage: [ choices objectAtIndex:index ] forState:UIControlStateNormal ];
}


-(void) setBoolValue:(BOOL)v{
	self.selectedIndex=v;
}


-(BOOL)boolValue{
	return self.selectedIndex;
}


-(void)toggle {
	if ( self.selectedIndex + 1 >= choices.count ){
		self.selectedIndex = 0;
	} else {
		self.selectedIndex = self.selectedIndex + 1;
	}
}

- (void)dealloc {
	[ choices release ];
    [super dealloc];
}


@end
