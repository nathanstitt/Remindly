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

	ToggleButton *button = [ [ ToggleButton alloc ] initWithImages: [ NSArray arrayWithObjects: 
																   [ UIImage imageNamed:@"ArrivingIcon.png" ],
																   [ UIImage imageNamed:@"DepartingIcon.png"], nil  ] 
			Frame: CGRectMake(0, 0, 30, 30 ) ];

	self.leftCalloutAccessoryView = button;
	
	self.draggable = YES;
	self.canShowCallout = YES;

	return self;
}	


- (void)setDragState:(MKAnnotationViewDragState)newDragState animated:(BOOL)animated
{
	[ map didChangeDragState:newDragState fromOldState:dragState];
	
    if (newDragState == MKAnnotationViewDragStateStarting) {
        // lift the pin and set the state to dragging
        CGPoint endPoint = CGPointMake(self.center.x,self.center.y-20);
        [UIView animateWithDuration:0.2
                         animations:^{ self.center = endPoint; }
                         completion:^(BOOL finished)
         { dragState = MKAnnotationViewDragStateDragging; }];
    } else if (newDragState == MKAnnotationViewDragStateEnding) {
        // drop the pin, and set state to none

        CGPoint endPoint = CGPointMake(self.center.x,self.center.y+20);
        [UIView animateWithDuration:0.2
                         animations:^{ self.center = endPoint; }
                         completion:^(BOOL finished)
         { dragState = MKAnnotationViewDragStateNone; [ map popUpCallOut ]; }];
    } else if (newDragState == MKAnnotationViewDragStateCanceling) {
        // drop the pin and set the state to none
		
        CGPoint endPoint = CGPointMake(self.center.x,self.center.y+20);
        [UIView animateWithDuration:0.2
                         animations:^{ self.center = endPoint; }
                         completion:^(BOOL finished)
         { dragState = MKAnnotationViewDragStateNone; [ map popUpCallOut ]; }];
    }
}

- (void)dealloc 
{
    [super dealloc];
}

@end



