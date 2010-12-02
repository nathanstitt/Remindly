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

	draw = [[ DrawingViewController alloc ] init ];
	draw.view.frame = CGRectMake(0, 0, 320, 420 );
	draw.note = [[ NotesManager instance ] defaultEditingNote ]; 
	[ self.view addSubview: draw.view ];



	dcm = [[ DrawingColorManager alloc] initWithColor:[ UIColor redColor ] ];
	dcm.delegate = self;
	[ self.view addSubview: dcm.toolBar ];


	mainToolbar = [[UIToolbar alloc] init];
	mainToolbar.barStyle = UIBarStyleBlack;
	mainToolbar.frame = CGRectMake( 0, 420, 320, 50 );
	[mainToolbar sizeToFit];

	UIImage *icon = [ UIImage imageNamed:@"photos_icon.png" ];
	NSString *count = @"1";
	countBtn = [ UIButton buttonWithType: UIButtonTypeCustom ];
    UIFont *font = [UIFont boldSystemFontOfSize:13];
    countBtn.titleLabel.font = font;
    countBtn.titleLabel.shadowOffset = CGSizeMake(0, -1);
    countBtn.titleEdgeInsets = UIEdgeInsetsMake( 0, -25, 0, 0);
    [ countBtn setImage:icon forState:UIControlStateNormal ];
    [ countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ countBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [ countBtn setTitleShadowColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [ countBtn setBackgroundImage:[UIImage imageNamed:@"bar-button-item-background.png"] forState:UIControlStateNormal];
	[ countBtn addTarget:self action: @selector(selectNotes:) forControlEvents:UIControlEventTouchUpInside ];
    countBtn.frame = CGRectMake( 0, 0, icon.size.width + 15 + [count sizeWithFont:font].width, 30 );

	UIBarButtonItem *opts = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(toggleOptions:) ];
	UIBarButtonItem *alarm =  [[UIBarButtonItem alloc ] initWithTitle:@"Alarm" style:UIBarButtonItemStyleBordered target:self action:@selector(setAlarm:) ];
	UIBarButtonItem *del = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteNote:) ];
	UIBarButtonItem *cnt = [[UIBarButtonItem alloc ] initWithCustomView:countBtn ];
	UIBarButtonItem *clear =  [[UIBarButtonItem alloc ] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearNote:) ];
	UIBarButtonItem *add   =  [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNote:) ];
	UIBarButtonItem *space = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:NULL ];
	
	mainToolbar.items = [NSArray arrayWithObjects: dcm.pickerButton, opts, add, clear, alarm, del, space, cnt, NULL ];

	toggledButtons=[[NSArray alloc ] initWithObjects:clear,alarm,add, del, NULL ];

	[ opts release  ];
	[ alarm release ];
	[ cnt release   ];
	[ clear release ];
	[ del release   ];
	[ add release   ];
	[ space release ];

	[self.view addSubview:mainToolbar ];
	
	alarmView = [[ AlarmView alloc ] init ];
	alarmView.delegate = self;
	[ self.view addSubview: alarmView ];

	[ scroll addNotes:[ NotesManager instance ].notes ];

	self.view.backgroundColor = [UIColor grayColor ];

	[ self updateCount ];
}


-(void)clearNote:(id)sel {
	[ draw clear ];
}


-(void)deleteNote:(id)sel{
	[ scroll deleteNote: draw.note ];
	draw.note = [[ NotesManager instance ] deleteNote:draw.note ];
	[ scroll selectNote: draw.note ];
	[ self updateCount ];
}


-(void)addNote:(id)sel{
	Note *n = [[ NotesManager instance ] addNote ];
	draw.note = n;
	[ scroll addNote:n ];
	[ self updateCount ];
}


-(void)alarmSet:(AlarmView*)av{
	[ alarmView saveToNote: draw.note ];
	[ draw noteUpdated ];
	[ draw.note scedule ];
}


-(void)setAlarm:(id)sel {
	alarmView.isShowing = YES;
}


-(void) updateCount {
	NSInteger c = [[[ NotesManager instance ] notes ] count];
	[ countBtn setTitle: [ NSString stringWithFormat:@"%ld", c ]	forState:UIControlStateNormal ];
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
	if ( draw.view.hidden  ){
		draw.view.hidden = NO;
		scroll.view.hidden = YES;
	} else {
		[ scroll reload:draw.note ];
		draw.view.hidden = YES;
		scroll.view.hidden = NO;
	}
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
