//
//  AlarmAnnotationView.m
//  Remindly
//
//  Created by Nathan Stitt on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlarmAnnotationView.h"
#import "ToggleButton.h"
#import "AlarmMapView.h"

@implementation AlarmAnnotationView


@synthesize delegate, dragState, map;

-initWithMap:(AlarmMapView*)m{
	map = m;
	self=[super initWithAnnotation: map.annotation reuseIdentifier:@"alarmIdentifier" ];
	if ( ! self ){
		return nil;
	}
	button = [ [ ToggleButton alloc ] initWithImages: [ NSArray arrayWithObjects: 
														[ UIImage imageNamed:@"DepartingIcon.png"],
													    [ UIImage imageNamed:@"ArrivingIcon.png" ],nil  ] 
													Frame: CGRectMake(0, 0, 30, 30 ) ];
	self.leftCalloutAccessoryView = button;
	self.draggable = YES;
	self.canShowCallout = YES;
	return self;
}	


- (void)setDragState:(MKAnnotationViewDragState)newDragState animated:(BOOL)animated {
	[ map didChangeDragState:newDragState fromOldState:dragState];
    if (newDragState == MKAnnotationViewDragStateStarting) {
        dragState = MKAnnotationViewDragStateDragging;
    } else if (newDragState == MKAnnotationViewDragStateEnding) {
		dragState = MKAnnotationViewDragStateNone;
    } else if (newDragState == MKAnnotationViewDragStateCanceling) {
		dragState = MKAnnotationViewDragStateNone;
    }
}


-(BOOL)onEnter{
	return [ button boolValue ];
}

-(void)setOnEnter:(BOOL)v{
	button.boolValue = v;
}

- (void)dealloc {
	[ button release ];
    [ super  dealloc ];
}

@end



