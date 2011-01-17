//
//  AlarmView.m
//  IoGee
//
//  Created by Nathan Stitt on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlarmView.h"
#import "AlarmQuickTimes.h"
#import "GradientButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation AlarmView

@synthesize wasSet,delegate;

- (id)init {
    
    self = [super initWithFrame:CGRectMake( 0, 480, 320, 320 )];
    if (self) {
        // Initialization code.
    }
	self.backgroundColor = [ UIColor blackColor ];

	self.layer.cornerRadius = 5;

	typeCtrl = [[ UISegmentedControl alloc ] initWithItems:
                          [ NSArray arrayWithObjects: @"Quick Selctions", @"Alarm Time", nil] ];
	typeCtrl.selectedSegmentIndex = 0;
	typeCtrl.frame = CGRectMake( 0, 0, 320, 30 );
	typeCtrl.segmentedControlStyle = UISegmentedControlStyleBezeled;
	typeCtrl.tintColor = [ UIColor darkGrayColor	];
	[ typeCtrl addTarget:self action:@selector(typeCtrlChanged:) forControlEvents:UIControlEventValueChanged ];
	[ self addSubview: typeCtrl ];
	[ typeCtrl release ];

	absTimes = [[AlarmAbsoluteTimes alloc ] init ];
	[ self addSubview: absTimes.view ];

	quickTimes = [[ AlarmQuickTimes alloc ] initWithAlarmView:self ];
	[ self addSubview: quickTimes.view ];

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


-(void)selectIndex:(NSInteger)i {
	typeCtrl.selectedSegmentIndex=i;
}

	
-(void)showWithNote:(Note*)note {
	[ quickTimes reset ];
	[ absTimes reset ];
	self.isShowing = YES;
	if ( NSOrderedDescending == [ note.fireDate compare:[NSDate date] ] ){
		if ( [ quickTimes hasDateType: note.alarmName ] ){
			[ quickTimes setFromNote: note ];
			[ self selectIndex: 0 ];
		} else {
			absTimes.date = note.fireDate;
			[ self selectIndex: 1 ];
		}
	} else {
		[ self selectIndex: 0 ];
	}
}


-(void)saveToNote:(Note*)note {
	if ( quickTimes.date ){
		[ quickTimes saveToNote: note ];
	} else {
		[ absTimes saveToNote: note ];
	}
}


-(void)typeCtrlChanged:(id)tc {
	if ( 0 == typeCtrl.selectedSegmentIndex ){
		quickTimes.view.hidden = NO;
		absTimes.view.hidden   = YES;
	} else if ( 1 == typeCtrl.selectedSegmentIndex ){
		if ( [quickTimes date ] ){
			absTimes.date = quickTimes.date;
			[ quickTimes reset ];
		}
		quickTimes.view.hidden = YES;
		absTimes.view.hidden   = NO;
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
	[ choicesTimes release ];
	[ quickChoices release ];
    [super dealloc];
}


@end
