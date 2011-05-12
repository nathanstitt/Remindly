//
//  PickerSelectionIndicator.m
//  Remindly
//
//  Created by Nathan Stitt on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PickerSelectionIndicator.h"
#import <QuartzCore/QuartzCore.h>

@implementation PickerSelectionIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:NO];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect f = self.frame;
    CGContextRef context = UIGraphicsGetCurrentContext();
    double perc = 0.18;
    
    CGContextMoveToPoint(context, f.size.width/2, f.size.height*perc );
    
    CGContextAddCurveToPoint(context, 
							 f.size.width/2, f.size.height*perc,
							 f.size.width/2, 0.0,
							 0.0, 0.0 );

    CGContextAddLineToPoint(context, f.size.width, 0.0 );

    CGContextAddCurveToPoint(context, 
							 f.size.width, 0.0,
							 f.size.width/2, 0.0,
							 f.size.width/2, f.size.height*perc );
    

    CGContextMoveToPoint(context, f.size.width/2, f.size.height*(1.0-perc) );

    CGContextAddCurveToPoint(context, 
							 f.size.width/2, f.size.height*(1.0-perc),
							 f.size.width/2, f.size.height,
							 f.size.width, f.size.height );

    CGContextAddLineToPoint(context, 0.0, f.size.height );

    CGContextAddCurveToPoint(context, 
							 0.0, f.size.height,
							 f.size.width/2, f.size.height,
							 f.size.width/2, f.size.height*(1.0-perc) );

	CGContextSetLineWidth(context, 1.0);
    CGContextSetFillColorWithColor(context, [ UIColor blackColor ].CGColor );
	CGContextDrawPath(context, kCGPathFillStroke);
    CGContextFillPath(context);
}


- (void)dealloc
{
    [super dealloc];
}

@end
