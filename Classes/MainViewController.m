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
#import "AlarmPopUpView.h"
#import "ColorButton.h"
#import "DrawingViewController.h"
#import "NotesManager.h"
#import "StoreView.h"
#import "NoteSelectorController.h"
#import "DrawingToolsPanel.h"


@implementation MainViewController

@synthesize drawing,selector,alarm,drawTools;

- (id)init {
    self = [super init ];


	selector = [[ NoteSelectorController alloc ] initWithMainView:self ];

	drawing = [[ DrawingViewController alloc ] initWithMainView:self ];
	drawing.view.frame = CGRectMake(0, 0, 320, 420 );
	//drawing.note = [ NotesManager noteAtIndex: 0 ]; 

	alarm = [[ AlarmPopUpView alloc ] init ];
    drawTools = [[DrawingToolsPanel alloc] init ];

	toolbar = [[MainToolBar alloc] initWithController:self];
	[ drawing.alarmTitle  addTarget:toolbar action:@selector(setAlarmPressed:) forControlEvents:UIControlEventTouchUpInside ];


	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDisplayNote:) name:@"DisplayNote" object:nil];

	self.view.backgroundColor = [ UIColor grayColor ];

    return self;
}


-(void)loadView {
    self.view = [ [ UIView alloc ] initWithFrame:CGRectMake(0, 0, 320, 480) ];
	[ self.view addSubview: drawing.view ];
    [ self.view addSubview: drawTools ];
	[ self.view addSubview: toolbar ];
	[ self.view addSubview: alarm ];

}


-(void) setDrawingMode:(BOOL)v {
	if ( v ){
		drawing.note = [ NotesManager noteAtIndex: [ selector currentIndex ] ];
        
        if ( [ selector isViewLoaded ] ){
            [ selector.view removeFromSuperview ];
        }
        drawing.view.hidden = NO;
	} else {
		Note *note = drawing.note;
        [ self.view insertSubview:selector.view belowSubview: drawing.view ];
		drawing.view.hidden  = YES;
		[selector selectNoteIndex: note.index ];

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
    if ( ! [ self drawingMode ] ){
        [ self setDrawingMode: YES ];
    }
}

-(void)onDisplayNote:(NSNotification*)notif{
	[ self selectNote:(Note*)notif.object ];
}


-(void)viewWillAppear:(BOOL)animated{
	[ super viewWillAppear:animated ];

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSNumber *index =[ prefs objectForKey:@"lastIndexEdited" ];
    if ( [index intValue] >= [ NotesManager count ] ){
        index = [ NSNumber numberWithInt: [ NotesManager count ] - 1 ];
    }
	[ drawing viewWillAppear:animated ];
	drawing.view.hidden = NO;
    drawing.note = [ NotesManager noteAtIndex: [ index intValue ] ];
}


-(void)viewWillDisappear:(BOOL)animated{
	[ super viewWillDisappear:animated ];
	Note *note = drawing.note;
    [note save];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [ prefs setObject:[ NSNumber numberWithInt: note.index ] forKey:@"lastIndexEdited" ];
    [ prefs synchronize ];
}


- (void)dealloc {
	[ toolbar release ];
	[ selector release ];
	[ drawing release ];
    [super dealloc];
}


@end
