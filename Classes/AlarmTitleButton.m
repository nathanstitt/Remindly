//
//  AlarmTitleLabel.m
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

#import "AlarmTitleButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation AlarmTitleButton

@synthesize borderWidth, borderRadius, borderColor, fillColor;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	self.backgroundColor = [UIColor clearColor];
	self.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
	[ self setTitleColor:[UIColor blackColor ] forState: UIControlStateNormal];

	self.borderColor = [UIColor colorWithWhite:0.65 alpha:1.0];
	self.fillColor = [ UIColor colorWithRed: 241.0/255.0
									  green:241.0/255.0 
									  blue:241.0/255.0 
									  alpha:1.0 ];


    return self;
}

#define borderWidth   1.0
#define borderRadius 10.0
#define PADDING       8.0

-(void)setText:(NSString*)text{
	if ( self.text.length != text.length ){
		[ self setNeedsDisplay ];
	}
	[ self setTitle:text forState:UIControlStateNormal ];
}

-(NSString*)text{
	return [ self titleForState:UIControlStateNormal ];
}

- (void)drawRect:(CGRect)rect {

	CGSize size = [[self text] sizeWithFont: self.titleLabel.font ];

	CGRect localRect = CGRectInset(rect, borderWidth / 2, borderWidth / 2);

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	NSInteger leftBorder = (160-PADDING)-(size.width/2);
	NSInteger bottom = localRect.size.height-5;
	NSInteger rightBorder = 320-leftBorder;
	CGContextTranslateCTM(context, borderWidth / 2, borderWidth / 2);

	CGContextMoveToPoint(context, leftBorder, 0.0 );
	CGContextAddLineToPoint(context, leftBorder, ( - borderRadius));

	CGContextAddCurveToPoint(context, 
							 leftBorder, bottom-borderRadius,
							 leftBorder, bottom,
							 leftBorder + borderRadius, bottom );

	CGContextAddLineToPoint(context, rightBorder-borderRadius, bottom);

	CGContextAddCurveToPoint(context, 
							 rightBorder-borderRadius, bottom,
							 rightBorder, bottom,
							 rightBorder, bottom - borderRadius );

	CGContextAddLineToPoint(context, rightBorder, 0 );

	[self.fillColor setFill     ];
	[self.borderColor setStroke ];
	CGContextSetLineWidth(context, borderWidth);

	CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 1.0, [UIColor grayColor ].CGColor );
	
	CGContextDrawPath(context, kCGPathFillStroke);
	
	CGContextRestoreGState(context);

	[ super drawRect:rect ];

}


- (void)dealloc {
    [super dealloc];
}


@end
