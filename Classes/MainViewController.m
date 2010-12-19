//
//  MainViewController.m
//  IoGee
//
//  Created by Nathan Stitt on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "AlarmView.h"
#import "ColorButton.h"
#import "DrawingViewController.h"
#import "NotesManager.h"

@implementation MainViewController

- (id)init {
    self = [super init ];
    return self;
}

- (void)viewDidLoad {

	scroll = [[ ScrollController alloc ] initWithMainView:self ];
	scroll.view.frame = CGRectMake(0, 0, 320, 420 );
	scroll.view.hidden = YES;
	[ self.view addSubview: scroll.view ];

	draw = [[ DrawingViewController alloc ] initWithMainView:self ];
	draw.view.frame = CGRectMake(0, 0, 320, 420 );
	draw.note = [[ NotesManager instance ] defaultEditingNote ]; 
	[ self.view addSubview: draw.view ];

	dcm = [[ DrawingColorManager alloc] initWithLastColor ];
	dcm.delegate = self;
	draw.color = dcm.selectedColor.CGColor;
	[ self.view addSubview: dcm.toolBar ];

	mainToolbar = [[UIToolbar alloc] init];
	mainToolbar.barStyle = UIBarStyleBlack;
	mainToolbar.frame = CGRectMake( 0, 420, 320, 50 );
	[mainToolbar sizeToFit];

	countBtn = [[ CountingButton alloc ] initWithCount: [[[ NotesManager instance ] notes ] count] ];
	[ countBtn.button addTarget:self action: @selector(selectNotes:) forControlEvents:UIControlEventTouchUpInside ];

	
	UIBarButtonItem *del    = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteNote:) ];
	UIBarButtonItem *alarm  = [[UIBarButtonItem alloc ] initWithImage:[UIImage imageNamed:@"alarm-clock-icon" ] style:UIBarButtonItemStylePlain target:self action:@selector(setAlarmPressed:) ];
	UIBarButtonItem *add    = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNote:) ];

	eraseBtn = [[DrawEraseButton alloc ] initWithDrawingState: YES ];
	[ eraseBtn.button addTarget:self action: @selector(toggleErase:) forControlEvents:UIControlEventTouchUpInside ];

	UIBarButtonItem *space  = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:NULL ];

	mainToolbar.items = [ NSArray arrayWithObjects:   dcm.pickerButton, space, add, space, del, space, eraseBtn, space, alarm, space, countBtn, NULL ];

	toggledButtons=[[NSArray alloc ] initWithObjects: dcm.pickerButton, add, del, eraseBtn, alarm,  NULL ];

	[ del   release  ];
	[ add   release  ];
	[ alarm release ];
	[ space release  ];

	[self.view addSubview:mainToolbar ];
	
	alarmView = [[ AlarmView alloc ] init ];
	alarmView.delegate = self;
	[ self.view addSubview: alarmView ];

	[ scroll addNotes:[ NotesManager instance ].notes ];

	self.view.backgroundColor = [UIColor grayColor ];

}

-(void)deleteNote:(id)sel {
	[ scroll deleteNote: draw.note ];
	draw.note = [[ NotesManager instance ] deleteNote:draw.note ];
	[ scroll selectNote: draw.note ];
	[ self updateCount ];
}

-(void)toggleErase:(id)sel{
	draw.isErasing = ! draw.isErasing;
	eraseBtn.isErasing = draw.isErasing;
}

-(void)addNote:(id)sel{
	Note *n = [[ NotesManager instance ] addNote ];
	draw.note = n;
	[ scroll addNote:n ];
	[ self updateCount ];
}

-(void)setAlarmPressed:(id)sel {
	[ self showAlarm ];
}

-(void)showAlarm{
	[ draw.note save ];
	[ alarmView showWithNote: draw.note ];
}

-(void) updateCount {
	[ countBtn setCount:[[[ NotesManager instance ] notes ] count] ];
}


-(void) selectNote:(Note*)note{
	draw.note = note;
	[ scroll selectNote:note ];
	if ( draw.view.hidden ){
		draw.view.hidden   = NO;
		scroll.view.hidden = YES;
	}
}


-(void) noteWasSelected:(Note*)note{
	for ( UIBarButtonItem *btn in toggledButtons ){
		[ btn setEnabled: YES ];
	}
	draw.note = note;
	draw.view.hidden   = NO;
	scroll.view.hidden = YES;
}


-(void)viewWillAppear:(BOOL)animated{
	[ super viewWillAppear:animated ];
	[ draw viewWillAppear:animated ];
	for ( UIBarButtonItem *btn in toggledButtons ){
		[ btn setEnabled: YES ];
	}
}


-(void)viewWillDisappear:(BOOL)animated{
	[ super viewWillDisappear:animated ];
	[ draw.note save ];
}


-(void)selectNotes:(id)btn {
	for ( UIBarButtonItem *btn in toggledButtons ){
		[ btn setEnabled: draw.view.hidden ];
	}
	draw.hidden = ! draw.hidden;
	scroll.hidden = ! scroll.hidden;
	if ( ! scroll.hidden ) {
		[ scroll reload:draw.note ];
	}
}

#pragma mark AlarmView delegate methods

-(void)alarmShowingChanged:(AlarmView*)av{
//	draw.alarmLabel.hidden = av.isShowing;
}

-(void)alarmSet:(AlarmView*)av{
	[ alarmView saveToNote: draw.note ];
	[ draw.note scedule ];
	[ draw noteUpdated ];
}

#pragma mark DrawingColorManagerDelegate delegate methods 

-(void)drawingColorManagerColorUpdated:(DrawingColorManager*)manager color:(CGColorRef)color{
	draw.color = color;
}

- (void)dealloc {
	[ alarmView release ];
	[ countBtn release ];
	[ draw release ];
	[ scroll release ];
	[ toggledButtons release ];
	[ mainToolbar release ];
	[ optionsToolbar release ];
    [super dealloc];
}


@end
