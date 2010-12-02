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

	self.lineBreakMode = UILineBreakModeTailTruncation;
	self.textAlignment = UITextAlignmentCenter;
	self.numberOfLines = 0;
	self.backgroundColor = [ UIColor lightGrayColor ];
	
	self.borderWidth = 1.0;
	self.borderRadius = 10.0;
	self.borderColor = [UIColor colorWithWhite:0.65 alpha:1.0];
	self.fillColor = [UIColor whiteColor];
	self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0]; 


//	self.layer.shadowOffset = CGSizeMake(3.0, 3.0);
//	self.layer.shadowOpacity = float;

    return self;
}


- (void)drawRect:(CGRect)rect {
	
	CGRect localRect = CGRectInset(rect, self.borderWidth / 2, self.borderWidth / 2);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	
	CGContextTranslateCTM(context, self.borderWidth / 2, self.borderWidth / 2);
	
	// create the border - we start at the top left edge (without including the edge itself) and move around counter-clockwise
	CGContextMoveToPoint(context, 0.0, 0.0 );
	CGContextAddLineToPoint(context, 0.0, (localRect.size.height - self.borderRadius));
	CGContextAddCurveToPoint(context, 0.0, localRect.size.height,
							 self.borderRadius, localRect.size.height,
							 self.borderRadius, localRect.size.height);

	CGContextAddLineToPoint(context, localRect.size.width , localRect.size.height);

	CGContextAddLineToPoint(context, localRect.size.width, 0 );

	CGContextAddLineToPoint(context, 0.0 , 0.0);

	CGContextRestoreGState(context);

	[self.fillColor setFill];
	[self.borderColor setStroke];
	CGContextSetLineWidth(context, self.borderWidth);

//	CGContextSetShadowWithColor(context, CGSizeMake(0, 20), 3.0, [UIColor redColor ].CGColor );
	
	CGContextDrawPath(context, kCGPathFillStroke);
	
	CGContextSaveGState(context);


	[ super drawRect:rect ];

}


- (void)dealloc {
    [super dealloc];
}


@end
