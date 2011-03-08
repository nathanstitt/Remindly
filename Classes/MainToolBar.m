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
#import "UIColor+Expanded.h"
#import "DrawingPaletteController.h"
#import "DrawingPaletteTool.h"

@implementation MainToolBar

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

	UIBarButtonItem *text  =  [[UIBarButtonItem alloc ] initWithImage:[UIImage imageNamed:@"text_icon" ] style:UIBarButtonItemStylePlain target:self action:@selector(addTextPressed:) ];
	UIBarButtonItem *alarm  = [[UIBarButtonItem alloc ] initWithImage:[UIImage imageNamed:@"alarm_icon" ] style:UIBarButtonItemStylePlain target:self action:@selector(setAlarmPressed:) ];

	eraseBtn = [[DrawEraseButton alloc ] initWithDrawingState: YES ];
	[ eraseBtn.button addTarget:self action: @selector(toggleErase:) forControlEvents:UIControlEventTouchUpInside ];
	
	UIBarButtonItem *space  = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:NULL ];


    ColorButton *b = [[ ColorButton alloc ] initWithColor: mvc.drawTools.color ];
    [ b  setBrushImage: [ mvc.drawTools.tool imageView ].image ];
    [ b addTarget:self action:@selector(showColors:) forControlEvents:UIControlEventTouchUpInside ];
	pickerBtn = [[UIBarButtonItem alloc ] initWithCustomView: b ];
	[ b release ];
    
		
	UIBarButtonItem *add = [[ UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNote:) ];

	drawButtons=[ NSArray arrayWithObjects: add, space, pickerBtn, space, eraseBtn, space, text, space, alarm, space, countBtn, NULL ];
	[ drawButtons retain ];
	[add release ];
    
	self.items = drawButtons;
    
	add = [[ UIBarButtonItem alloc ] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addNote:) ];
	UIBarButtonItem *done = [[ UIBarButtonItem alloc ] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleDrawingMode:) ];

    UIBarButtonItem *backward = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(noteBackward:) ];

    UIBarButtonItem *forward = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(noteForward:) ];

	selButtons  = [ NSArray arrayWithObjects:  add, space, backward, space, forward, space, done, NULL ];
	[ selButtons retain ];

    [ backward release ];
    [ forward  release ];
	[ add   release  ];
	[ alarm release  ];
	[ text  release  ];
	[ space release  ];
    [ done  release  ];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countChanged:) name:NOTES_COUNT_CHANGED_NOTICE object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drawingBegan:) name:DRAWING_BEGAN_NOTIFICATION object:nil];
	
    [ mvc.drawTools addObserver:self forKeyPath:@"color" options:(NSKeyValueObservingOptionNew ) context:NULL];

    [ mvc.drawTools addObserver:self forKeyPath:@"tool" options:(NSKeyValueObservingOptionNew ) context:NULL];
    mvc.drawing.lineWidth = mvc.drawTools.tool.drawingWidth;
    
	return self;
}


-(void) showColors:(id)sel{
    mvc.isDrawToolsShowing = ! mvc.isDrawToolsShowing;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ( [ keyPath isEqual:@"color" ] ) {
        ((ColorButton*)pickerBtn.customView).color = mvc.drawing.color = mvc.drawTools.color;
    } else if ( [ keyPath isEqual:@"tool" ] ){
        mvc.drawing.lineWidth = ( ( mvc.drawTools.tool.tag * 3.0 ) + 1 );
        [ ((ColorButton*)pickerBtn.customView) setBrushImage: [ mvc.drawTools.tool imageView ].image ];
    }
}

-(void)noteBackward:(id)btn {
    [ mvc.selector selectNoteIndex:  [ mvc.selector currentIndex ] - 1 ];
}

-(void)noteForward:(id)btn {
    [ mvc.selector selectNoteIndex:  [ mvc.selector currentIndex ] + 1 ];
}

-(void)drawingBegan:(NSNotification*)note {
	if ( mvc.alarm.isShowing ){
		mvc.alarm.isShowing=NO;
	}
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
	mvc.isDrawToolsShowing = NO;
}


-(void)countChanged:(NSNotification*)notif	{
	[ countBtn setCount:[ NotesManager count ] ];
}


-(void)addNote:(id)sel{
	NotesManager *manager = [ NotesManager instance ];
	if ( [ manager isAllowedMoreNotes ] ){
		mvc.drawing.note = [ manager addNote ];
		mvc.drawingMode = YES;
		[ mvc.selector addNote: mvc.drawing.note ];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No more reminders"
														message:@"You've reached the maximum number of reminders.\n\nWould you like to view options for purchasing additional reminders?"  
													   delegate:self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil];
		[alert show];
		[alert release];
	}
	mvc.isDrawToolsShowing = NO;
}


-(void)addTextPressed:(id)sel{
	[ mvc.drawing addText ];
	mvc.isDrawToolsShowing = NO;
}


-(void)showAlarm {
	mvc.isDrawToolsShowing = NO;
    mvc.isAlarmShowing = ! mvc.isAlarmShowing;
}


-(void)setAlarmPressed:(id)sel {
	[ self showAlarm ];
}


-(void)toggleDrawingMode:(id)btn {
	[ mvc toggleDrawingMode ];
	mvc.isDrawToolsShowing = NO;
}

#pragma mark UIAlertViewDelegate delegate methods

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ( 1 == buttonIndex ){
		StoreView *store = [[ StoreView alloc ] initAndShowInto: mvc.view ];
		[ store release ];
	}
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self ];
	[ drawButtons release ];
	[ selButtons release ];
	[ eraseBtn release ];
    [super dealloc];
}


@end
