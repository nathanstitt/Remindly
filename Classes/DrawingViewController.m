//
//  DrawingView.m
//  IoGee
//
//  Created by Nathan Stitt on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "MainViewController.h"
#import "AlarmTitleLabel.h"
#import "NotesManager.h"
#import "DrawingViewController.h"

@implementation DrawingViewController

@synthesize note,color,isErasing;

- (id)initWithMainView:(MainViewController*)mv {
    self = [super init ];
	mainView = mv;
	self.view.backgroundColor = [ UIColor whiteColor ];

	drawImage = [[UIImageView alloc] initWithImage:nil];
	drawImage.frame = CGRectMake(0, 0, self.view.frame.size.width, 420);

	[ self.view addSubview:drawImage];
	color = [ UIColor darkGrayColor ].CGColor;

	alarmLabel = [[AlarmTitleLabel alloc ] initWithFrame:CGRectMake( 0, 0, 320, 27 ) ];
	
	[ self.view addSubview:alarmLabel ];

	[ NSTimer scheduledTimerWithTimeInterval:1
									target:self 
									selector:@selector(updateTitle:) 
									userInfo:nil 
									repeats:YES ];
	
	mouseMoved = 0;
    return self;
}

- (void)clearPoints {
        for ( NSInteger i=0; i<4; i++){
                points[i] = CGPointZero;
        }       
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
	
	UITouch *touch = [touches anyObject];

	[ self clearPoints ];
	points[0] = lastPoint = [touch locationInView:self.view];
}

- (CGFloat)distanceBetweenPoint:(CGPoint)a andPoint:(CGPoint)b {
    CGFloat a2 = powf(a.x-b.x, 2.f);
    CGFloat b2 = powf(a.y-b.y, 2.f);
    return sqrtf(a2 + b2);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

	UITouch *touch = [touches anyObject];	
	
	wasMoved = YES;

	CGPoint currentPoint = [touch locationInView:self.view];

    if ( [ self distanceBetweenPoint:points[0] andPoint: currentPoint ] < 10 ){
		return;
	}

	for ( NSInteger i=3; i>0; i--){
		points[i] = points[i-1];
	}
	points[0] = currentPoint;

	if ( CGPointEqualToPoint( CGPointZero , points[3] ) ){
		return;
	}

	UIGraphicsBeginImageContext(self.view.frame.size);
	[ drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.isErasing ? 20.0 :  5.0 );

	CGContextSetStrokeColorWithColor( UIGraphicsGetCurrentContext(), 
									 self.isErasing ? [ UIColor whiteColor].CGColor : color );

	CGContextBeginPath(UIGraphicsGetCurrentContext());

	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), points[3].x, points[3].y);

	CGPoint first = points[0];

	points[0].y = (points[0].y + points[1].y) / 2;
	points[0].x = (points[0].x + points[1].x) / 2;

	CGPoint end = points[0];

	CGContextAddCurveToPoint(UIGraphicsGetCurrentContext(), 
                                                         points[2].x,
                                                         points[2].y,
                                                         points[1].x,
                                                         points[1].y,
                                                         points[0].x,
                                                         points[0].y );

	[ self clearPoints ];
	points[0] = first;
	points[1] = end;

	CGContextStrokePath(UIGraphicsGetCurrentContext());
	
	drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	lastPoint = end;

	mouseMoved++;

	if (mouseMoved == 10) {
		mouseMoved = 0;
	}

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	NSLog(@"Touches Ended");

	UIGraphicsBeginImageContext(self.view.frame.size);
	[drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);

	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.isErasing ? 20.0 :  5.0 );
	CGContextSetStrokeColorWithColor( UIGraphicsGetCurrentContext(), 
									 self.isErasing ? [ UIColor whiteColor].CGColor : color );


	CGPoint currentPoint = [[touches anyObject] locationInView:self.view];

	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
	
	if( wasMoved ){
		CGContextAddQuadCurveToPoint( UIGraphicsGetCurrentContext(), 
								 points[0].x,
								 points[0].y,
								 currentPoint.x,
								 currentPoint.y );
	} else {
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
	}
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	CGContextFlush(UIGraphicsGetCurrentContext());
	drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
