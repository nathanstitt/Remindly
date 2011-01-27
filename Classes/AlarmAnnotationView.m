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
																   [ UIImage imageNamed:@"ArrivingIcon.png" ],
																   [ UIImage imageNamed:@"DepartingIcon.png"], nil  ] 
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
		[ map setupOverlay ];
        // lift the pin and set the state to dragging
//        CGPoint endPoint = CGPointMake(self.center.x,self.center.y-20);
//        [UIView animateWithDuration:0.2
//                         animations:^{ self.center = endPoint; }
//                         completion:^(BOOL finished)
//         { dragState = MKAnnotationViewDragStateDragging; }];
    } else if (newDragState == MKAnnotationViewDragStateEnding) {
        // drop the pin, and set state to none
		dragState = MKAnnotationViewDragStateNone;
		[ map setupOverlay ];
//        CGPoint endPoint = CGPointMake(self.center.x,self.center.y+20);
//        [UIView animateWithDuration:0.9
//                         animations:^{ self.center = endPoint; }
//                         completion:^(BOOL finished)
//         { dragState = MKAnnotationViewDragStateNone; [ map setupOverlay ]; } ];
    } else if (newDragState == MKAnnotationViewDragStateCanceling) {
		dragState = MKAnnotationViewDragStateNone;
//        // drop the pin and set the state to none
//		
//        CGPoint endPoint = CGPointMake(self.center.x,self.center.y+20);
//        [UIView animateWithDuration:0.2
//                         animations:^{ self.center = endPoint; }
//                         completion:^(BOOL finished)
//         { dragState = MKAnnotationViewDragStateNone; if ( finished ) { [ map setupOverlay ]; } }];
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



