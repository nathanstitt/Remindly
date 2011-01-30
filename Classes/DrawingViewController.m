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

#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"
#import "AlarmTitleButton.h"
#import "NotesManager.h"
#import "DrawingViewController.h"
#import "DrawingTextBox.h"


@implementation DrawingViewController

@synthesize note,color,isErasing,alarmTitle;

- (id)initWithMainView:(MainViewController*)mv {
    self = [super init ];
	mainView = mv;
	self.view.backgroundColor = [ UIColor whiteColor ];

	drawImage = [[UIImageView alloc] initWithImage:nil];
	drawImage.frame = CGRectMake(0, 0, self.view.frame.size.width, 420);

	[ self.view addSubview:drawImage];
	color = [ UIColor darkGrayColor ].CGColor;

	alarmTitle = [[AlarmTitleButton alloc ] initWithFrame:CGRectMake( 0, 0, 320, 27 ) ];
	[ self.view addSubview:alarmTitle ];

	[ NSTimer scheduledTimerWithTimeInterval:1
									target:self 
									selector:@selector(updateTitle:) 
									userInfo:nil 
									repeats:YES ];

    return self;
}



- (void)clearPoints {
        for ( NSInteger i=0; i<4; i++){
                points[i] = CGPointZero;
        }       
}

-(void)addText{
	DrawingTextBox *pv = [[ DrawingTextBox alloc ] initWithTextBlob: [ note addTextBlob ] ];
	[self.view addSubview: pv ];
	[ pv liftUp ];
	wasMoved = NO;
	currentTextEditBox = pv;
	pv.isEditing = YES;
	[ pv release];
	
}

-(void)updateTitle:(id)sel {
	alarmTitle.text = [ note alarmTitle ];
}

-(void)setNote:(Note *)n{
	if ( note != n ){
		note.image = drawImage.image;
		[ note save ];
		[ note release ];
		[ n retain ];
		note = n;
	}
	for ( UIView *view in self.view.subviews  ){
		if ([ view isKindOfClass:[DrawingTextBox class] ]){ 
			[ view removeFromSuperview];
		}
	}
	for ( NoteTextBlob *text in note.textBlobs ){
		DrawingTextBox *pv = [[ DrawingTextBox alloc ] initWithTextBlob: text ];
		[self.view addSubview: pv ];
		[ pv release];
	}
	drawImage.image = note.image;
	[ self updateTitle:NULL ];


}




-(Note*)note{
	note.image = drawImage.image;
	alarmTitle.hidden = YES;
	UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [[UIScreen mainScreen] scale]);
	CGContextRef context = UIGraphicsGetCurrentContext();
    [ self.view.layer renderInContext:context ];
	note.thumbnail = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	alarmTitle.hidden = NO;
	return note;
}

#define GROW_ANIMATION_DURATION_SECONDS 0.15
#define SHRINK_ANIMATION_DURATION_SECONDS 0.15

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint currentPoint = [touch locationInView:self.view];
	wasMoved = NO;

	// Only move the placard view if the touch was in the placard view
	if ([[touch view] isKindOfClass:[DrawingTextBox class] ]){ 
		[ (DrawingTextBox*)[touch view] liftUp ];
		return;
	}
	
	[ self clearPoints ];
	points[0] = lastPoint = currentPoint;
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

	// Only move the placard view if the touch was in the placard view
	if ([[touch view] isKindOfClass:[DrawingTextBox class] ]){ 
		[ (DrawingTextBox*)[touch view] moveTo: currentPoint ];
		return;
	}

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

}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	NSLog(@"Touches Ended");
	UITouch *touch = [touches anyObject];	
	CGPoint currentPoint = [touch locationInView:self.view];

	if ([[touch view] isKindOfClass:[DrawingTextBox class] ]){ 
		if ( wasMoved ){
			[ (DrawingTextBox*)[touch view] moveToAndDrop:currentPoint ];
		} else {
			currentTextEditBox = (DrawingTextBox*)[touch view] ;
			[ currentTextEditBox setIsEditing:YES ];
		}
		
		return;
	}
	if ( currentTextEditBox && ! wasMoved ){
		currentTextEditBox.isEditing = NO;
		currentTextEditBox = nil;
		return;
	}
	if ( [ self distanceBetweenPoint:points[0] andPoint: currentPoint ] < 10 ){
		return;
	}
	UIGraphicsBeginImageContext(self.view.frame.size);
	[drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);

	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.isErasing ? 20.0 :  5.0 );
	CGContextSetStrokeColorWithColor( UIGraphicsGetCurrentContext(), 
									 self.isErasing ? [ UIColor whiteColor].CGColor : color );
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
