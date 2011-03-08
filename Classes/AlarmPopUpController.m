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


#import "AlarmPopUpController.h"
#import "AlarmQuickTimes.h"
#import "GradientButton.h"
#import <QuartzCore/QuartzCore.h>


@implementation AlarmPopUpController

@synthesize wasSet;


-(void)loadView {
    self.view = [ [ UIView alloc ] initWithFrame:CGRectMake( 0, 480, 320, 480 ) ];
  
	self.view.backgroundColor = [ UIColor blackColor ];

    panels = [ NSMutableArray arrayWithObjects:
              [[[ UIView alloc ] initWithFrame: CGRectMake(0, 20, 320, 390 ) ] autorelease ],
              NULL
              ];
    [ panels retain ];
	quickTimes = [[ AlarmQuickTimes alloc ] initWithAlarmView:self frame:CGRectMake( 0, 185, 320, 320) ];
	absTimes = [[AlarmAbsoluteTimes alloc ] initWithAlarmView:self frame:CGRectMake(0.0, 0.0, 320.0, 90.0)];

	[ [ panels objectAtIndex:0 ] addSubview: quickTimes.view ];
	[ [ panels objectAtIndex:0 ] addSubview: absTimes.view ];

    UIView *hbar = [ [UIView alloc ] initWithFrame: CGRectMake( 0, 207, 320, 8) ];
    hbar.backgroundColor = [ UIColor blackColor ];
    [ [ panels objectAtIndex:0 ] addSubview: hbar ];
    [ hbar release ];
    
    UIView *lvbar = [ [UIView alloc ] initWithFrame: CGRectMake( 0, 120, 10, 200 ) ];
    lvbar.backgroundColor = [ UIColor blackColor ];
    [ [ panels objectAtIndex:0 ] addSubview: lvbar ];
    [ lvbar release ];

    UIView *rvbar = [ [UIView alloc ] initWithFrame: CGRectMake( 310, 120, 10, 200 ) ];
    rvbar.backgroundColor = [ UIColor blackColor ];
    [ [ panels objectAtIndex:0 ] addSubview: rvbar ];
    [ rvbar release ];

	NSArray *titles;
	if ( YES || [CLLocationManager significantLocationChangeMonitoringAvailable] ){
        mapView = [[ AlarmMapView alloc ] initWithAlarmView:self frame:CGRectMake(0, 0, 320, 415 )];
        [ panels addObject: mapView.view ];
		titles = [ NSArray arrayWithObjects: @"Time/Date", @"Map", nil]; 
	} else {
		titles = [ NSArray arrayWithObjects: @"Time/Date", nil];
	}

    for ( UIView *v in panels ){
        [ self.view addSubview: v ];
    }
 
	typeCtrl = [[ UISegmentedControl alloc ] initWithItems:titles];
	typeCtrl.selectedSegmentIndex = 0;

	typeCtrl.frame = CGRectMake( 0, 0, 320, 30 );
	typeCtrl.segmentedControlStyle = UISegmentedControlStyleBezeled;
	typeCtrl.tintColor = [ UIColor darkGrayColor	];
	[ typeCtrl addTarget:self action:@selector(typeCtrlChanged:) forControlEvents:UIControlEventValueChanged ];
	[ self.view addSubview: typeCtrl ];
	[ typeCtrl release ];

    
	GradientButton *b = [ [ GradientButton alloc ] initWithFrame: CGRectMake(20, 425, 120, 35 ) ];
	[ b addTarget:self action:@selector(cancelTouched:) forControlEvents:UIControlEventTouchUpInside ];
	[ b setTitle:@"Cancel" forState:UIControlStateNormal ];
	[ b useBlackStyle ];
	[ self.view addSubview: b ];
	[ b release ];

	b = [ [ GradientButton alloc ] initWithFrame: CGRectMake(170, 425, 120, 35 ) ];
	[ b addTarget:self action:@selector(saveTouched:) forControlEvents:UIControlEventTouchUpInside ];
	[ b setTitle:@"Save" forState:UIControlStateNormal ];
	[ b useBlueStyle ];
	[ self.view addSubview: b ];
	[ b release ];

}

-(void) viewDidUnload {
	[ quickTimes  release ];
	[ absTimes    release ];
	[ mapView     release ];
	[ typeCtrl    release ];
	[ currentNote release ];
    [ panels release ];
}


- (void)dealloc {
    [ super viewDidUnload ];
    [ super dealloc ];
}


-(void)cancelTouched:(id)btn {
	self.isShowing = NO;
}


-(void)saveTouched:(id)btn {
	switch ( typeCtrl.selectedSegmentIndex ) {
		case 0:
            if ( [ quickTimes isSet ] ){
                [ quickTimes saveToNote: currentNote ];
            } else {
                [ absTimes saveToNote: currentNote ];
            }
			break;
		case 1:
			[ mapView saveToNote: currentNote ];
			break;
		default:
			break;
	}
	[ currentNote save ];
	[ currentNote scedule ];
	self.isShowing = NO;
}



-(void)hideAll{
    for ( UIView *v in panels ){
        v.hidden = YES;
    }
}


-(void)typeCtrlChanged:(id)tbc {
    [ self hideAll ];
    NSInteger indx = typeCtrl.selectedSegmentIndex;
    ((UIView*)[ panels objectAtIndex: indx ]).hidden = NO;
}

	
-(void)showWithNote:(Note*)note {
	currentNote = note;
	[ quickTimes reset ];
	[ mapView reset ];
	[ absTimes reset ];
	[ self hideAll ];
	self.isShowing = YES;

	switch ( note.alarmTag ) {
		case 0:
			[ quickTimes setFromNote:note ];
            typeCtrl.selectedSegmentIndex = 0;
			break;
		case 1:
            typeCtrl.selectedSegmentIndex = 0;
			absTimes.date = note.fireDate;
			break;
		case 2:
            typeCtrl.selectedSegmentIndex = 1;
			[ mapView setFromNote:note ];
			break;
	}
    [ self typeCtrlChanged:nil ];
}


-(void)quickSelectionMade {
	NSDate *d = [ quickTimes.date retain ];
	if ( d ){
		absTimes.date = d;
	}
	[ d release ];
}


-(void)absSelectionMade{
    [ quickTimes selectBlank ];
}

-(void)setIsShowing:(BOOL)v {
	CGRect frame = self.view.frame;
	if ( v ){
		typeCtrl.selectedSegmentIndex = 0;
		frame.origin.y = 0;
	} else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault ];
		frame.origin.y = 480;
	}
    [UIView animateWithDuration:0.4f animations:^{
        self.view.frame = frame;
    } completion:^ (BOOL finished) {
        if ( v ){
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque ];
        }
    }];

}


-(BOOL)isShowing{
	return ( self.view.frame.origin.y < 420 );
}


@end
