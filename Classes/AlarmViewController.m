//
//  AlarmView.m
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


#import "AlarmViewController.h"
#import "AlarmQuickTimes.h"
#import "GradientButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation AlarmViewController

@synthesize wasSet,delegate;

- (id)init {
    
    self = [super initWithFrame:CGRectMake( 0, 480, 320, 320 )];
    if (self) {
        // Initialization code.
    }
	self.backgroundColor = [ UIColor blackColor ];

	self.layer.cornerRadius = 5;

	quickTimes = [[ AlarmQuickTimes alloc ] initWithAlarmView:self ];
	[ self addSubview: quickTimes.view ];

	absTimes = [[AlarmAbsoluteTimes alloc ] initWithAlarmView:self ];
	[ self addSubview: absTimes.view ];

	NSArray *titles;
	if ( [CLLocationManager regionMonitoringAvailable] && [CLLocationManager regionMonitoringEnabled] ){
		mapView = [[ AlarmMapView alloc ] initWithAlarmView:self ];
		[ self addSubview: mapView.view ];
		titles = [ NSArray arrayWithObjects: @"Shortcuts", @"Time/Date", @"Map", nil]; 
	} else {
		titles = [ NSArray arrayWithObjects: @"Shortcuts", @"Time/Date", nil];
	}


	typeCtrl = [[ UISegmentedControl alloc ] initWithItems:titles];
	typeCtrl.selectedSegmentIndex = 0;
	typeCtrl.frame = CGRectMake( 0, 0, 320, 30 );
	typeCtrl.segmentedControlStyle = UISegmentedControlStyleBezeled;
	typeCtrl.tintColor = [ UIColor darkGrayColor	];
	[ typeCtrl addTarget:self action:@selector(typeCtrlChanged:) forControlEvents:UIControlEventValueChanged ];
	[ self addSubview: typeCtrl ];
	[ typeCtrl release ];
	
	GradientButton *b = [ [ GradientButton alloc ] initWithFrame: CGRectMake(35, 250, 80, 30 ) ];
	[ b addTarget:self action:@selector(cancelTouched:) forControlEvents:UIControlEventTouchUpInside ];
	[ b setTitle:@"Cancel" forState:UIControlStateNormal ];
	[ b useBlackStyle ];
	[ self addSubview: b ];
	[ b release ];

	b = [ [ GradientButton alloc ] initWithFrame: CGRectMake(200, 250, 80, 30 ) ];
	[ b addTarget:self action:@selector(saveTouched:) forControlEvents:UIControlEventTouchUpInside ];
	[ b setTitle:@"Save" forState:UIControlStateNormal ];
	[ b useBlackStyle ];
	[ self addSubview: b ];
	[ b release ];

    return self;
}


-(void)cancelTouched:(id)btn {
	self.isShowing = NO;
}


-(void)saveTouched:(id)btn {
	self.isShowing = NO;
	if ( delegate ){
		[ delegate alarmSet:self ];
	}
}

-(CGRect)childFrame{
	return CGRectMake(0, 30, 320, 220);
}

-(void)selectIndex:(NSInteger)indx {
	typeCtrl.selectedSegmentIndex=indx;
	switch (indx) {
		case 0:
			quickTimes.view.hidden=NO;
			break;
		case 1:
			absTimes.view.hidden=NO;
			break;
		case 2:
			mapView.view.hidden=NO;
			break;
		default:
			break;
	} 
}


-(void)hideAll{
	quickTimes.view.hidden = YES;
	absTimes.view.hidden = YES;
	mapView.view.hidden = YES;
}

	
-(void)showWithNote:(Note*)note {
	[ quickTimes reset ];
	[ absTimes reset ];
	[ self hideAll ];
	self.isShowing = YES;
	switch ( note.alarmTag ) {
		case 0:
			[ quickTimes setFromNote:note ];
			[ self selectIndex: 0 ];
			break;
		case 1:
			absTimes.date = note.fireDate;
			[ self selectIndex: 1 ];
		case 2:
			[ mapView setFromNote:note ];
			[ self selectIndex: 2 ];
		default:
			break;
	}
}


-(void)saveToNote:(Note*)note {
	switch ( typeCtrl.selectedSegmentIndex ) {
		case 0:
			[ quickTimes saveToNote: note ];
			break;
		case 1:
			[ absTimes saveToNote: note ];
			break;
		case 2:
			[ mapView saveToNote: note ];
			break;
		default:
			break;
	}
	note.alarmTag = typeCtrl.selectedSegmentIndex;	
	[ note save ];
}


-(void)typeCtrlChanged:(id)tc {
	[ self hideAll ];
	if ( 0 == typeCtrl.selectedSegmentIndex ){
		quickTimes.view.hidden = NO;
	} else if ( 1 == typeCtrl.selectedSegmentIndex ){
		if ( [quickTimes date ] ){
			absTimes.date = quickTimes.date;
			[ quickTimes reset ];
		}
		absTimes.view.hidden   = NO;
	} else if ( 2 == typeCtrl.selectedSegmentIndex ){
		mapView.view.hidden = NO;
	}
}


-(void)quickSelectionMade {
	NSDate *d = [ quickTimes.date retain ];
	if ( d ){
		absTimes.date = d;
	}
	[ d release ];
}


-(void)setIsShowing:(BOOL)v {
	CGRect frame = self.frame;
	NSInteger ht = self.frame.size.height;
	if ( v ){
		[ self selectIndex:0 ];
		frame.origin.y = 480 - ( ht - 20 );
	} else {
		frame.origin.y = 480;
	}
	[ UIView beginAnimations:nil context:NULL ];
	[ UIView setAnimationDuration:0.45f ];
	self.frame = frame;
	[ UIView commitAnimations ];
	if ( delegate ){
		[ delegate alarmShowingChanged: self ];
	}
}


-(BOOL)isShowing{
	return ( self.frame.origin.y < 420 );
}


- (void)dealloc {
	[ quickTimes   release ];
    [super dealloc];
}


@end
