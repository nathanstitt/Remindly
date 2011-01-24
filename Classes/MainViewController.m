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

#import "MainViewController.h"
#import "AlarmViewController.h"
#import "ColorButton.h"
#import "DrawingViewController.h"
#import "NotesManager.h"
#import "StoreView.h"
#import "NoteSelectorController.h"

@interface MainViewController()
-(void) updateCount;
-(void) showAlarm;
@end



@implementation MainViewController

- (id)init {
    self = [super init ];
    return self;
}

- (void)viewDidLoad {

	scroll = [[ NoteSelectorController alloc ] initWithMainView:self ];
	scroll.view.frame = CGRectMake(0, 0, 320, 420 );
	scroll.view.hidden = YES;
	[ self.view addSubview: scroll.view ];

	draw = [[ DrawingViewController alloc ] initWithMainView:self ];
	draw.view.frame = CGRectMake(0, 0, 320, 420 );
	draw.note = [ NotesManager noteAtIndex: 0 ]; 
	[ draw.alarmTitle   addTarget:self action:@selector(setAlarmPressed:) forControlEvents:UIControlEventTouchUpInside ];
	
	[ self.view addSubview: draw.view ];

	dcm = [[ DrawingColorController alloc] initWithLastColor ];
	dcm.delegate = self;
	draw.color = dcm.selectedColor.CGColor;
	[ self.view addSubview: dcm.toolBar ];

	mainToolbar = [[UIToolbar alloc] init];
	mainToolbar.barStyle = UIBarStyleBlack;
	mainToolbar.frame = CGRectMake( 0, 420, 320, 50 );
	[ mainToolbar sizeToFit ];

	countBtn = [[ CountingButton alloc ] initWithCount: [ NotesManager count] ];

	[ countBtn.button addTarget:self action: @selector(showScroller:) forControlEvents:UIControlEventTouchUpInside ];

	UIBarButtonItem *del    = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteNote:) ];
	UIBarButtonItem *alarm  = [[UIBarButtonItem alloc ] initWithImage:[UIImage imageNamed:@"alarm" ] style:UIBarButtonItemStylePlain target:self action:@selector(setAlarmPressed:) ];
	UIBarButtonItem *add    = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNote:) ];

	eraseBtn = [[DrawEraseButton alloc ] initWithDrawingState: YES ];
	[ eraseBtn.button addTarget:self action: @selector(toggleErase:) forControlEvents:UIControlEventTouchUpInside ];

	UIBarButtonItem *space  = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:NULL ];

	mainToolbar.items = [ NSArray arrayWithObjects:   dcm.pickerButton, space, add, space, del, space, eraseBtn, space, alarm, space, countBtn, NULL ];

	toggledButtons=[[NSArray alloc ] initWithObjects: dcm.pickerButton, add, del, eraseBtn, alarm,  NULL ];

	[ del   release  ];
	[ add   release  ];
	[ alarm release  ];
	[ space release  ];

	[self.view addSubview:mainToolbar ];
	
	alarmView = [[ AlarmViewController alloc ] init ];
	alarmView.delegate = self;
	[ self.view addSubview: alarmView ];



	self.view.backgroundColor = [UIColor grayColor ];

}

-(void)deleteNote:(id)sel {
	Note *note = draw.note;
	draw.note = [[ NotesManager instance ] deleteNote: note ];
	[ scroll deleteNote: note newIndex:draw.note.index ];

	[ self updateCount ];
}

-(void)toggleErase:(id)sel{
	draw.isErasing = ! draw.isErasing;
	eraseBtn.isErasing = draw.isErasing;
}

-(void)addNote:(id)sel{
	NotesManager *manager = [ NotesManager instance ];
	if ( [ manager isAllowedMoreNotes ] ){
		Note *n = [ manager addNote ];
		draw.note = n;
		[ scroll addNote:n ];
		[ self updateCount ];
	} else {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No more reminders"
									message:@"You've reached the maximum number of reminders.\n\nWould you like to view options for purchasing additional reminders?"  
									delegate:self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil];
		[alert show];
		[alert release];
	}
}

-(void)setAlarmPressed:(id)sel {
	[ self showAlarm ];
}

-(void)showAlarm{
	if ( alarmView.isShowing ){
		alarmView.isShowing=NO;
	} else {
		[ draw.note save ];
		[ alarmView showWithNote: draw.note ];
	}
		
		
}

-(void) updateCount {
	[ countBtn setCount:[ NotesManager count ] ];
}


-(void) selectNote:(Note*)note{
	draw.note = note;
	[ scroll selectNoteIndex:note.index ];
	if ( draw.view.hidden ){
		draw.view.hidden   = NO;
		scroll.view.hidden = YES;
	}
	for ( UIBarButtonItem *btn in toggledButtons ){
		[ btn setEnabled: YES ];
	}
	
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


-(void)showScroller:(id)btn {
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

-(void)alarmShowingChanged:(AlarmViewController*)av{
//	draw.alarmLabel.hidden = av.isShowing;
}

-(void)alarmSet:(AlarmViewController*)av{
	[ alarmView saveToNote: draw.note ];
	[ draw.note scedule ];
	[ draw noteUpdated ];
}

#pragma mark UIAlertViewDelegate delegate methods
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ( 1 == buttonIndex ){
		StoreView *store = [[ StoreView alloc ] initAndShowInto: self.view ];
		[ store release ];
	}
}

#pragma mark DrawingColorManagerDelegate delegate methods 

-(void)drawingColorManagerColorUpdated:(DrawingColorController*)manager color:(CGColorRef)color{
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
