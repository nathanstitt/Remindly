//
//  AlarmView.m
//  IoGee
//
//  Created by Nathan Stitt on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlarmView.h"
#import "AlarmQuickTimes.h"

#import <QuartzCore/QuartzCore.h>

@implementation AlarmView

@synthesize wasSet,delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
	self.backgroundColor = [ UIColor blackColor ];

	self.layer.cornerRadius = 5;
	
	UISegmentedControl *typeCtrl = [[ UISegmentedControl alloc ] initWithItems:
                                              [ NSArray arrayWithObjects: @"Quick Times", @"Custom Time", nil]      
											];
	
	typeCtrl.selectedSegmentIndex = 0;
	typeCtrl.frame = CGRectMake( 0, 0, 320, 30 );
	typeCtrl.segmentedControlStyle = UISegmentedControlStyleBezeled;
	typeCtrl.tintColor = [ UIColor blackColor ];
                //sortBtns.momentary = YES;
//                [ typeCtrl addTarget:self action:@selector(changeSort:) forControlEvents:UIControlEventValueChanged ];
	[ self addSubview: typeCtrl ];
	[ typeCtrl release ];
	

	qt = [[ AlarmQuickTimes alloc ] initWithAlarmView:self ];
	[ self addSubview: qt.view ];

    return self;
}


-(void)toggleShowing {
	self.isShowing = ! self.isShowing;
}

-(void)setIsShowing:(BOOL)v {
	CGRect frame = self.frame;
	NSInteger ht = self.frame.size.height;
	if ( v ){
		frame.origin.y = 420 - ( ht - 20 );
	} else {
		frame.origin.y = 420;
	}
	[ UIView beginAnimations:nil context:NULL ];
	[ UIView setAnimationDuration:0.45f ];
	self.frame = frame;
	[ UIView commitAnimations ];
	
}


-(void)setFromNote:(Note*)note {
	if ( note.alarmName ){
		[ qt setFromNote:note ];
	}
}

-(void)saveToNote:(Note*)note {
	if ( qt.wasSet ){
		[ qt saveToNote:note ];
	}
}


-(void)quickSelectionMade {
	self.isShowing = NO;
	if ( delegate ){
		[ delegate alarmSet:self ];
	}
}

-(BOOL)isShowing{
	return ( self.frame.origin.y < 420 );
}

- (void)dealloc {
	[ qt           release ];
	[ choicesTimes release ];
	[ quickChoices release ];
    [super dealloc];
}


@end
