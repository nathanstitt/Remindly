//
//  ColorButton.m
//  Mr Naggles
//
//  Created by Nathan Stitt on 11/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

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
	
	//CGContextSetGrayFillColor(context, 0.1, 0.5);

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
