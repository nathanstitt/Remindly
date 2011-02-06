//
//  AlarmAnnotationView.m
//  Remindly
//
//  Created by Nathan Stitt on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlarmAnnotationPin.h"
#import "ToggleButton.h"
#import "AlarmMapView.h"

#import "AlarmAnnotationLabel.h"

@implementation AlarmAnnotationPin


@synthesize delegate, dragState, map, button, label;

-initWithMap:(AlarmMapView*)m {
	map = m;
    AlarmAnnotationLabel *l = [[ AlarmAnnotationLabel alloc ] init ];
	self=[super initWithAnnotation: l reuseIdentifier:@"alarmIdentifier" ];
	if ( ! self ){
        [ l release ];
		return nil;
	}
    label = l;
	button = [ [ ToggleButton alloc ] initWithImages: [ NSArray arrayWithObjects: 
														[ UIImage imageNamed:@"DepartingIcon.png"],
													    [ UIImage imageNamed:@"ArrivingIcon.png" ],nil  ] 
													Frame: CGRectMake(0, 0, 30, 30 ) ];
    label = self.annotation;
	button.toggleOnTouch = NO;
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
	
    self.label.entering = button.boolValue = v;
}

- (void)dealloc {
    [ label release ];
	[ button release ];
    [ super  dealloc ];
}

@end



