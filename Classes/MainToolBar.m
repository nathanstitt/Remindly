//
//  MainToolBar.m
//  Remindly
//
//  Created by Nathan Stitt on 1/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainToolBar.h"
#import "MainViewController.h"
#import "NotesManager.h"
#import "DrawingViewController.h"
#import "NoteSelectorController.h"
#import "StoreView.h"

@implementation MainToolBar

-(UIBarButtonItem*)makeBarButton:(UIColor*)c{
	ColorButton *b = [[ ColorButton alloc ] iniWithColor: c.CGColor ];
	[ b addTarget:self action:@selector(colorSelected:) forControlEvents:UIControlEventTouchUpInside ];
	UIBarButtonItem *bbt = [[UIBarButtonItem alloc ] initWithCustomView: b ];
	[ b release ];
	return [ bbt autorelease ];
}


-(id)initWithController:(MainViewController*)m {
	self = [ super init ];
	if ( ! self ){
		return nil;
	}
	mvc = m;
	self.barStyle = UIBarStyleBlack;
	self.frame = CGRectMake( 0, 420, 320, 50 );
	[ self sizeToFit ];

	countBtn = [[ CountingButton alloc ] initWithCount: [ NotesManager count] ];
	
	[ countBtn.button addTarget:self action: @selector(toggleDrawingMode:) forControlEvents:UIControlEventTouchUpInside ];
	
	UIBarButtonItem *text  =  [[UIBarButtonItem alloc ] initWithImage:[UIImage imageNamed:@"text-icon" ] style:UIBarButtonItemStylePlain target:self action:@selector(addTextPressed:) ];
	UIBarButtonItem *alarm  = [[UIBarButtonItem alloc ] initWithImage:[UIImage imageNamed:@"alarm" ] style:UIBarButtonItemStylePlain target:self action:@selector(setAlarmPressed:) ];

	GradientButton *addb = [[ GradientButton alloc ] initWithFrame:CGRectMake(0,0, 100, 25 ) ];
	[ addb setTitle: @"New Note" forState:UIControlStateNormal ];

	UIBarButtonItem *add = [[ UIBarButtonItem alloc ] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addNote:) ];
	eraseBtn = [[DrawEraseButton alloc ] initWithDrawingState: YES ];
	[ eraseBtn.button addTarget:self action: @selector(toggleErase:) forControlEvents:UIControlEventTouchUpInside ];
	
	UIBarButtonItem *space  = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:NULL ];

	pickerBtn = [ self makeBarButton: [UIColor lightGrayColor]];
	[ pickerBtn retain ];
	[ ((ColorButton*)pickerBtn.customView) removeTarget:self action:@selector(colorSelected:) forControlEvents:UIControlEventTouchUpInside ];
	[ ((ColorButton*)pickerBtn.customView) addTarget:self action:@selector(showColors:) forControlEvents:UIControlEventTouchUpInside ];
	
	drawButtons=[ NSArray arrayWithObjects:   pickerBtn, space, eraseBtn, space, text, space, alarm, space, countBtn, NULL ];
	[ drawButtons retain ];
	self.items = drawButtons;

	selButtons  = [ NSArray arrayWithObjects:  add, NULL ];
	[ selButtons retain ];
	
	[ add   release  ];
	[ alarm release  ];
	[ text  release  ];
	[ space release  ];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countChanged:) name:NOTES_COUNT_CHANGED_NOTICE object:nil];

	colorButtons = [ NSArray arrayWithObjects:
	 [ self makeBarButton:[UIColor blackColor] ],
	 [ self makeBarButton:[UIColor darkGrayColor ] ],
	 [ self makeBarButton:[UIColor lightGrayColor ] ],
	 [ self makeBarButton:[UIColor grayColor ] ],
	 [ self makeBarButton:[UIColor redColor ] ],
	 [ self makeBarButton:[UIColor greenColor ] ],
	 [ self makeBarButton:[UIColor blueColor ] ],
	 [ self makeBarButton:[UIColor cyanColor ] ],
	 [ self makeBarButton:[UIColor yellowColor ] ],
	 [ self makeBarButton:[UIColor magentaColor ] ],
	 [ self makeBarButton:[UIColor orangeColor ] ],
	 [ self makeBarButton:[UIColor purpleColor ] ],
	 [ self makeBarButton:[UIColor brownColor ] ],
	 NULL ];
	[ colorButtons retain ];
	
	
	
//	dcm = [[ DrawingColorController alloc] initWithLastColor ];
//	dcm.delegate = self;
	
//	mvc.drawing.color = dcm.selectedColor.CGColor;
//	[ mvc.view addSubview: dcm.toolBar ];
	
	return self;
}


-(void)colorSelected:(ColorButton*)cv {
	mvc.drawing.color = [ cv color ];

	NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject: cv.color ];

	((ColorButton*)pickerBtn.customView).color = mvc.drawing.color;
	[ self setItems:drawButtons animated:YES];
}



-(void) showColors:(id)sel{
	[ self setItems:colorButtons animated:YES];	
}



-(void) setDrawingMode:(BOOL)draw{
	if ( draw ){
		[ self setItems: drawButtons animated:YES];	
	} else {
		[ self setItems: selButtons  animated:YES];	
	}
}


-(void)toggleErase:(id)sel{
	mvc.drawing.isErasing = ! mvc.drawing.isErasing;
	eraseBtn.isErasing = mvc.drawing.isErasing;
	
}

-(void)countChanged:(NSNotification*)notif	{
	[ countBtn setCount:[ NotesManager count ] ];
}
	


-(void) setColor:(CGColorRef)color{
	mvc.drawing.color = color;
}



-(void)addNote:(id)sel{
	NotesManager *manager = [ NotesManager instance ];
	if ( [ manager isAllowedMoreNotes ] ){
		Note *n = [ manager addNote ];
		[ mvc.selector addNote:n ];
		mvc.drawing.note = n;
		mvc.drawingMode = YES;
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No more reminders"
														message:@"You've reached the maximum number of reminders.\n\nWould you like to view options for purchasing additional reminders?"  
													   delegate:self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil];
		[alert show];
		[alert release];
	}
}

-(void)addTextPressed:(id)sel{
	[ mvc.drawing addText ];
}

-(void)showAlarm{
	if ( mvc.alarm.isShowing ){
		mvc.alarm.isShowing=NO;
	} else {
		[ mvc.alarm showWithNote: mvc.drawing.note ];
	}
}



-(void)setAlarmPressed:(id)sel {
	[ self showAlarm ];
}



-(void)toggleDrawingMode:(id)btn {
	[ mvc toggleDrawingMode ];
}


#pragma mark UIAlertViewDelegate delegate methods
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ( 1 == buttonIndex ){
		StoreView *store = [[ StoreView alloc ] initAndShowInto: mvc.view ];
		[ store release ];
	}
}

#pragma mark DrawingColorManagerDelegate delegate methods 

-(void)drawingColorManagerColorUpdated:(DrawingColorController*)manager color:(CGColorRef)color{
	mvc.drawing.color = color;
}



- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self ];
	[ drawButtons release ];
	[ selButtons release ];
	[ colorBtn release ];
	[ eraseBtn release ];
    [super dealloc];
}


@end
