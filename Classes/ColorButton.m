//
//  ColorButton.m
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

#import "ColorButton.h"


@implementation ColorButton

@synthesize color;

- (id)iniWithColor:(CGColorRef)c {
	self = [ super initWithFrame:CGRectMake(0, 0, 25, 25) ];
	color = c;
    if ( self ) {
        // Initialization code.
    }
	self.backgroundColor = [ UIColor clearColor ];
    return self;
}

-(void)setColor:(CGColorRef)c{
	color = c;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextBeginPath(context);
	
	CGContextSetFillColorWithColor(context, color );
	

	NSInteger radius = self.frame.size.width / 2;

	CGContextMoveToPoint(context, CGRectGetMinX(rect) + self.frame.size.width, CGRectGetMinY(rect));
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius, radius, 0, M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect) - radius, radius, M_PI / 2, M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, M_PI, 3 * M_PI / 2, 0);	
    CGContextClosePath(context);
    CGContextFillPath(context);
}


- (void)dealloc {
    [super dealloc];
}


@end
