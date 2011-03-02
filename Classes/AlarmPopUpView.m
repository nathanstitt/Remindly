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


#import "AlarmPopUpView.h"
#import "AlarmQuickTimes.h"
#import "GradientButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation AlarmPopUpView

@synthesize wasSet;

- (id)init {
    
    self = [super initWithFrame:CGRectMake( 0, 480, 320, 480 )];
    if (!self) {
        return  nil;
    }
  
	self.backgroundColor = [ UIColor blackColor ];

	quickTimes = [[ AlarmQuickTimes alloc ] initWithAlarmView:self ];

	absTimes = [[AlarmAbsoluteTimes alloc ] initWithAlarmView:self ];

	[ self addSubview: quickTimes.view ];
	[ self addSubview: absTimes.view ];

	NSArray *titles;
	if ( YES || [CLLocationManager significantLocationChangeMonitoringAvailable] ){
		mapView = [[ AlarmMapView alloc ] initWithAlarmView:self ];
		[ self addSubview: mapView.view ];
		titles = [ NSArray arrayWithObjects: @"Time/Date", @"Map", nil]; 
	} else {
		titles = [ NSArray arrayWithObjects: @"Time/Date", nil];
	}

	typeCtrl = [[ UISegmentedControl alloc ] initWithItems:titles];
	typeCtrl.selectedSegmentIndex = 0;
	typeCtrl.frame = CGRectMake( 0, 0, 320, 30 );
	typeCtrl.segmentedControlStyle = UISegmentedControlStyleBezeled;
	typeCtrl.tintColor = [ UIColor darkGrayColor	];
	[ typeCtrl addTarget:self action:@selector(typeCtrlChanged:) forControlEvents:UIControlEventValueChanged ];
	[ self addSubview: typeCtrl ];
	[ typeCtrl release ];

	GradientButton *b = [ [ GradientButton alloc ] initWithFrame: CGRectMake(20, 425, 120, 35 ) ];
	[ b addTarget:self action:@selector(cancelTouched:) forControlEvents:UIControlEventTouchUpInside ];
	[ b setTitle:@"Cancel" forState:UIControlStateNormal ];
	[ b useBlackStyle ];
	[ self addSubview: b ];
	[ b release ];

	b = [ [ GradientButton alloc ] initWithFrame: CGRectMake(170, 425, 120, 35 ) ];
	[ b addTarget:self action:@selector(saveTouched:) forControlEvents:UIControlEventTouchUpInside ];
	[ b setTitle:@"Save" forState:UIControlStateNormal ];
	[ b useBlueStyle ];
	[ self addSubview: b ];
	[ b release ];

    return self;
}


-(void)cancelTouched:(id)btn {
	self.isShowing = NO;
}


-(void)saveTouched:(id)btn {
	switch ( typeCtrl.selectedSegmentIndex ) {
		case 0:
            if ( absTimes.wasSet ){
                [ absTimes saveToNote: currentNote ];
            } else {
                [ quickTimes saveToNote: currentNote ];
            }
			break;
		case 2:
			[ mapView saveToNote: currentNote ];
			break;
		default:
			break;
	}
//	currentNote.alarmTag = typeCtrl.selectedSegmentIndex;	
	[ currentNote save ];
	[ currentNote scedule ];
	self.isShowing = NO;
}



-(void)hideAll{
	quickTimes.view.hidden = YES;
	absTimes.view.hidden = YES;
	mapView.view.hidden = YES;
}


-(void)typeCtrlChanged:(id)tbc {
	if ( 0 ==  typeCtrl.selectedSegmentIndex ){
        mapView.view.hidden = YES;
		quickTimes.view.hidden = NO;
        absTimes.view.hidden = NO;
	} else if ( 1 == typeCtrl.selectedSegmentIndex ){
		mapView.view.hidden = NO;
		quickTimes.view.hidden = YES;
        absTimes.view.hidden = YES;
	}
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


-(void)setIsShowing:(BOOL)v {
	CGRect frame = self.frame;


	if ( v ){
		typeCtrl.selectedSegmentIndex = 0;
		frame.origin.y = 0;
	} else {
        [[UIApplication sharedApplication] setStatusBarHidden: v ];


		frame.origin.y = 480;
	}
    [UIView animateWithDuration:0.4f animations:^{
        self.frame = frame;
    }
    completion:^ (BOOL finished) {
        
        self.superview.frame = [UIScreen mainScreen].applicationFrame;

        [[UIApplication sharedApplication] setStatusBarHidden: v ];
    }];

}


-(BOOL)isShowing{
	return ( self.frame.origin.y < 420 );
}


- (void)dealloc {
	[ quickTimes   release ];
    [super dealloc];
}


@end
