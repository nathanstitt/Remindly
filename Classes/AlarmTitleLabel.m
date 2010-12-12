//
//  AlarmTitleLabel.m
//  Mr Naggles
//
//  Created by Nathan Stitt on 11/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlarmTitleLabel.h"
#import <QuartzCore/QuartzCore.h>


@implementation AlarmTitleLabel

@synthesize borderWidth, borderRadius, borderColor, fillColor;



- (id)initWithFrame:(CGRect)frame {
   self = [super initWithFrame:frame];

	self.backgroundColor = [UIColor clearColor];
	self.lineBreakMode = UILineBreakModeTailTruncation;
	self.textAlignment = UITextAlignmentCenter;
	self.numberOfLines = 0;
	
	self.borderColor = [UIColor colorWithWhite:0.65 alpha:1.0];
	self.fillColor = [UIColor whiteColor];


    return self;
}

#define borderWidth   1.0
#define borderRadius 10.0


- (void)drawRect:(CGRect)rect {

	CGSize size = [[self text] sizeWithFont:[self font]];
	
	CGRect localRect = CGRectInset(rect, borderWidth / 2, borderWidth / 2);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	NSInteger leftBorder = 155-(size.width/2);
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

	[self.fillColor setFill];
	[self.borderColor setStroke];
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
