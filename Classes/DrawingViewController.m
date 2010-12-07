//
//  DrawingView.m
//  IoGee
//
//  Created by Nathan Stitt on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DrawingViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation DrawingViewController

@synthesize note,color,isErasing;

- (id)init {
    self = [super init ];
	self.view.backgroundColor = [ UIColor whiteColor ];

	drawImage = [[UIImageView alloc] initWithImage:nil];
	drawImage.frame = CGRectMake(0, 0, self.view.frame.size.width, 420);

	[ self.view addSubview:drawImage];
	color = [ UIColor darkGrayColor ].CGColor;

	alarmLabel = [[UILabel alloc ] initWithFrame:CGRectMake( 0, 0, 320, 25 ) ];
	alarmLabel.textAlignment = UITextAlignmentCenter;
	alarmLabel.backgroundColor = [UIColor clearColor];
	alarmLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
    alarmLabel.shadowOffset = CGSizeMake(0, -1.0);
	
	[ self.view addSubview:alarmLabel ];

	[ NSTimer scheduledTimerWithTimeInterval:30
									target:self 
								   selector:@selector(updateTitle:) 
									userInfo:nil 
									repeats:YES ];


	mouseMoved = 0;
    return self;
}



-(void)updateTitle:(id)sel {
	alarmLabel.text = [note alarmDescription];
}

-(void)setNote:(Note *)n{
	if ( note != n ){
		[ note release ];
		[ n retain ];
		note = n;
		[ self noteUpdated ];
	}
}


- (void)noteUpdated {
	[ self updateTitle:NULL ];
	mouseMoved = 0;
	drawImage.image = note.image;
}


-(Note*)note{
	note.image = drawImage.image;
	return note;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	alarmLabel.hidden = YES;
	
	UITouch *touch = [touches anyObject];
	if ([touch tapCount] == 2) {
//		drawImage.image = nil;
//		return;
	}
		

	lastPoint = [touch locationInView:self.view];
	//lastPoint.y -= 20;

}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

	UITouch *touch = [touches anyObject];	
	pointBeforeLast = lastPoint;

	CGPoint currentPoint = [touch locationInView:self.view];

	UIGraphicsBeginImageContext(self.view.frame.size);
	[ drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.isErasing ? 20.0 :  5.0 );
	CGContextSetStrokeColorWithColor( UIGraphicsGetCurrentContext(), 
									 self.isErasing ? [ UIColor whiteColor].CGColor : color );

	CGContextBeginPath(UIGraphicsGetCurrentContext());

	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
	CGContextAddCurveToPoint(UIGraphicsGetCurrentContext(), 
                                                         pointBeforeLast.x,
                                                         pointBeforeLast.y,
                                                         lastPoint.x,
                                                         lastPoint.y,
                                                         currentPoint.x,
                                                         currentPoint.y );

//  CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);

	CGContextStrokePath(UIGraphicsGetCurrentContext());
	drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	lastPoint = currentPoint;

	mouseMoved++;

	if (mouseMoved == 10) {
		mouseMoved = 0;
	}

}

- (void)clear {
	drawImage.image = nil;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	NSLog(@"Touches Ended");

	alarmLabel.hidden = NO;
	
	UIGraphicsBeginImageContext(self.view.frame.size);
	[drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);

	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.isErasing ? 20.0 :  5.0 );
	CGContextSetStrokeColorWithColor( UIGraphicsGetCurrentContext(), 
									 self.isErasing ? [ UIColor whiteColor].CGColor : color );

	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	CGContextFlush(UIGraphicsGetCurrentContext());
	drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
