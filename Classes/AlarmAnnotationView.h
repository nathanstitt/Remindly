//
//  AlarmAnnotationView.h
//  Remindly
//
//  Created by Nathan Stitt on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "AlarmAnnotation.h"

@class ToggleButton;

@interface AlarmAnnotationView : MKPinAnnotationView 
{
    id <MKMapViewDelegate> delegate;
    MKAnnotationViewDragState dragState;
	ToggleButton *button;
}

-initWithMap:(AlarmMapView*)map;

@property (nonatomic) BOOL onEnter;
@property (nonatomic, assign) id <MKMapViewDelegate> delegate;
@property (nonatomic, assign) MKAnnotationViewDragState dragState;
@property (nonatomic, assign) AlarmMapView *map;

@end

