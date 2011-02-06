//
//  AlarmAnnotationView.h
//  Remindly
//
//  Created by Nathan Stitt on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@class ToggleButton,AlarmMapView,AlarmAnnotationLabel;

@interface AlarmAnnotationPin : MKPinAnnotationView 
{
    id <MKMapViewDelegate> delegate;
    MKAnnotationViewDragState dragState;
	ToggleButton *button;
    AlarmAnnotationLabel *label;
}

-initWithMap:(AlarmMapView*)map;
@property (nonatomic,readonly) ToggleButton *button;
@property (nonatomic,readonly) AlarmAnnotationLabel *label;
@property (nonatomic) BOOL onEnter;
@property (nonatomic, assign) id <MKMapViewDelegate> delegate;
@property (nonatomic, assign) MKAnnotationViewDragState dragState;
@property (nonatomic, assign) AlarmMapView *map;

@end

