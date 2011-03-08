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
#import <QuartzCore/QuartzCore.h> 

@implementation ColorButton

@synthesize color,marked;

- (id)initWithColor:(UIColor*)c {
	self = [ super initWithFrame:CGRectMake(0, 0, 25, 25) ];
    if ( ! self ) {
		return nil;
    }
	self.color = c;
	self.backgroundColor = [ UIColor clearColor ];
    
    self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.layer.shadowOpacity = 1.5f;
    self.layer.shadowColor = [UIColor clearColor].CGColor;
    self.layer.shadowRadius = 2.5f;
    self.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
    
    return self;
}


-(void)setColor:(UIColor*)c{
	if ( color != c ) {
		[ c retain ];
		[ color release ];
		color = c;
	}
	[self setNeedsDisplay];
}

-(void)setMarked:(BOOL)m {
    if ( m != marked ){
        marked = m;
        if ( marked ){
            self.frame = CGRectMake(self.frame.origin.x - 2, self.frame.origin.y - 2, 
                                    self.frame.size.width+4, self.frame.size.height+4);
            self.layer.shadowColor = [UIColor blackColor].CGColor;

        } else {
            self.frame = CGRectMake(self.frame.origin.x + 2, self.frame.origin.y + 2,
                                    self.frame.size.width-4, self.frame.size.height-4);
            self.layer.shadowColor = [UIColor clearColor].CGColor;
        }
        [ self setNeedsDisplay ];
    }
}

- (void)setBrushImage:(UIImage*)img {
    if ( img != image ){
        [ image release ];
        image = [img retain];
        [ self setNeedsDisplay ];
    }

}

- (void)drawRect:(CGRect)rect {
    

    CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGContextBeginPath(context);
    
    
	CGContextSetFillColorWithColor(context, color.CGColor );
	NSInteger radius = self.frame.size.width / 2;
	CGContextMoveToPoint(context, CGRectGetMinX(rect) + self.frame.size.width, CGRectGetMinY(rect));
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 3 * M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius, radius, 0, M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect) - radius, radius, M_PI / 2, M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, M_PI, 3 * M_PI / 2, 0);
   
    CGContextClosePath(context);
    CGContextFillPath(context);

    if ( image ){
        rect.size.height = rect.size.height - 4;
        rect.origin.y    = rect.origin.y    + 4;
        rect.origin.x    = rect.origin.x    + 3;
        [image drawInRect:rect];
    }

}

- (void)dealloc {
	[ color release ];
    [ super dealloc ];
}


@end
