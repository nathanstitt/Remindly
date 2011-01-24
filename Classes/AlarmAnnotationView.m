//
//  AlarmAnnotationView.m
//  Remindly
//
//  Created by Nathan Stitt on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlarmAnnotationView.h"
#import "ToggleButton.h"

@implementation AlarmAnnotationView


@synthesize delegate, dragState, mapView;


-(id) initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	if ( ! self ){
		return nil;
	}

	ToggleButton *button = [ [ ToggleButton alloc ] initWithImages: [ NSArray arrayWithObjects: 
																   [ UIImage imageNamed:@"flag.png" ],
																   [UIImage imageNamed:@"SFIcon.png"], nil  ] 
			Frame: CGRectMake(0, 0, 20, 20 ) ];

	self.leftCalloutAccessoryView = button;
	
	return self;
}	


- (void)setDragState:(MKAnnotationViewDragState)newDragState animated:(BOOL)animated
{
    [delegate mapView:mapView annotationView:self didChangeDragState:newDragState fromOldState:dragState];
	
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
         { dragState = MKAnnotationViewDragStateNone; }];
    } else if (newDragState == MKAnnotationViewDragStateCanceling) {
        // drop the pin and set the state to none
		
        CGPoint endPoint = CGPointMake(self.center.x,self.center.y+20);
        [UIView animateWithDuration:0.2
                         animations:^{ self.center = endPoint; }
                         completion:^(BOOL finished)
         { dragState = MKAnnotationViewDragStateNone; }];
    }
}

- (void)dealloc 
{
    [super dealloc];
}

@end



