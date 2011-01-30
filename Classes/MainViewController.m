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


@implementation MainViewController

@synthesize drawing,selector,alarm;

- (id)init {
    self = [super init ];


	selector = [[ NoteSelectorController alloc ] initWithMainView:self ];
	selector.view.frame = CGRectMake(0, 0, 320, 420 );
	selector.view.hidden = YES;
	[ self.view addSubview: selector.view ];

	drawing = [[ DrawingViewController alloc ] initWithMainView:self ];
	drawing.view.frame = CGRectMake(0, 0, 320, 420 );
	drawing.note = [ NotesManager noteAtIndex: 0 ]; 
	[ drawing.alarmTitle   addTarget:self action:@selector(setAlarmPressed:) forControlEvents:UIControlEventTouchUpInside ];
	[ self.view addSubview: drawing.view ];

	toolbar = [[MainToolBar alloc] initWithController:self];
	[self.view addSubview: toolbar ];
	
	alarm = [[ AlarmViewController alloc ] init ];
	[ self.view addSubview: alarm ];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDisplayNote:) name:@"DisplayNote" object:nil];

	self.view.backgroundColor = [ UIColor grayColor ];

    return self;
}


-(void) setDrawingMode:(BOOL)v {
	if ( v ){
		drawing.note = [ NotesManager noteAtIndex: [ selector currentIndex ] ];
		drawing.view.hidden  = NO;
		selector.view.hidden = YES;
	} else {
		Note *note = drawing.note;
		selector.view.hidden = NO;
		drawing.view.hidden  = YES;
		[selector selectNoteIndex: note.index ];
		[selector reload: note ];
	}
	[ toolbar setDrawingMode:v ];
}


-(BOOL) drawingMode {
	return ! drawing.view.hidden;
}

-(void) toggleDrawingMode {
	self.drawingMode = ! self.drawingMode;
}

-(void) selectNote:(Note*)note{
	drawing.note = note;
	[ selector selectNoteIndex: note.index ];
	[ self setDrawingMode:YES ];
	
}

-(void)onDisplayNote:(NSNotification*)notif{
	[ self selectNote:(Note*)notif.object ];
}



-(void)viewWillAppear:(BOOL)animated{
	[ super viewWillAppear:animated ];
	[ drawing viewWillAppear:animated ];
	[ self setDrawingMode: YES ];
}


-(void)viewWillDisappear:(BOOL)animated{
	[ super viewWillDisappear:animated ];
	[ drawing.note save ];
}

- (void)dealloc {
	[ toolbar release ];
	[ selector release ];
	[ drawing release ];
    [super dealloc];
}


@end
