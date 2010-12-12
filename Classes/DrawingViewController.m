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

	alarmLabel = [[AlarmTitleLabel alloc ] initWithFrame:CGRectMake( 0, 0, 320, 27 ) ];
	
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
	}
	[ self noteUpdated ];
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
	
//	alarmLabel.hidden = YES;
	
	UITouch *touch = [touches anyObject];
	if ([touch tapCount] == 2) {
//		drawImage.image = nil;
//		return;
	}
		
	for ( NSInteger i=0; i<5; i++){
		points[i] = CGPointZero;
	}
	points[0] = [touch locationInView:self.view];

	lastPoint = [touch locationInView:self.view];
	//lastPoint.y -= 20;

}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

	UITouch *touch = [touches anyObject];	
	
	

	CGPoint currentPoint = [touch locationInView:self.view];
	for ( NSInteger i=4; i>0; i--){
		points[i] = points[i-1];
	}
	points[0] = [touch locationInView:self.view];
	
	if ( CGPointEqualToPoint( CGPointZero , points[2] ) ){
		return;
	}

	UIGraphicsBeginImageContext(self.view.frame.size);
	[ drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.isErasing ? 20.0 :  5.0 );

	CGContextSetStrokeColorWithColor( UIGraphicsGetCurrentContext(), 
									 self.isErasing ? [ UIColor whiteColor].CGColor : color );

	CGContextBeginPath(UIGraphicsGetCurrentContext());

	// need to do something like
	// http://stackoverflow.com/questions/1052119/how-can-i-trace-the-finger-movement-on-touch-for-drawing-smooth-curves
//	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), points[0].x, points[0].y );
//	CGContextAddQuadCurveToPoint( UIGraphicsGetCurrentContext(), 
//								 points[1].x,
//                                 points[1].y,
//                                 points[0].x,
//                                 points[0].y );
	
//	for ( NSInteger i=0; i<5; i++){
//		points[i] = CGPointZero;
//	}
//	CGContextAddCurveToPoint(UIGraphicsGetCurrentContext(), 
//                                                         points[3].x,
//                                                         points[3].y,
//                                                         points[2].x,
//                                                         points[2].y,
//                                                         points[1].x,
//                                                         points[1].y );

	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);

	CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(),  kCGInterpolationLow);
	CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), true);
	
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
	
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	
	drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	lastPoint = currentPoint;

	mouseMoved++;

	if (mouseMoved == 10) {
		mouseMoved = 0;
	}

}

-(BOOL)hidden {
	return self.view.hidden;
}

-(void)setHidden:(BOOL)h {
	self.view.hidden = h;
}

- (void)clear {
	drawImage.image = nil;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	NSLog(@"Touches Ended");

//	alarmLabel.hidden = NO;
	
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
