//
//  DrawingPalletteView.m
//  Remindly
//
//  Created by Nathan Stitt on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DrawingPaletteView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Expanded.h"

@implementation DrawingPaletteView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [ UIColor clearColor ];
    }
    return self;
}


 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
     CGContextRef context = UIGraphicsGetCurrentContext();
     CGContextSaveGState(context);
     CGRect f = self.frame;
     NSInteger radius = 40.0;
     
     CGContextMoveToPoint(context, 0.0, f.size.height );

     CGContextAddLineToPoint(context, 0.0, radius );
     
     CGContextAddCurveToPoint(context, 
                              0.0, radius,
                              0.0, 0.0,
                              radius, 0.0 );
     
     CGContextAddLineToPoint(context, f.size.width-radius, 0.0 );
     
     CGContextAddCurveToPoint(context, 
                              f.size.width-radius, 0.0,
                              f.size.width, 0.0, 
                              f.size.width, radius );

     CGContextAddLineToPoint(context, f.size.width, f.size.height );

     CGContextAddLineToPoint(context, 0.0, f.size.height );
     
//     [self.fillColor   [ UIColor colorWithHexString:@"9a9a9a" ]   ];
//     [self.borderColor setStroke ];
     CGContextSetFillColorWithColor( context, [ UIColor colorWithHexString:@"9a9a9a" ].CGColor );
     CGContextSetLineWidth(context, 1.0 );
     
     CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 1.0, [UIColor grayColor ].CGColor );
     
     CGContextDrawPath(context, kCGPathFillStroke);
     
     CGContextRestoreGState(context);
     [ UIColor colorWithHexString:@"9a9a9a" ];
     [ super drawRect:rect ];     
 }


- (void)dealloc
{
    [super dealloc];
}

@end
