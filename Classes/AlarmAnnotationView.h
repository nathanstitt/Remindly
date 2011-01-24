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

@interface AlarmAnnotationView : MKPinAnnotationView 
{
    id <MKMapViewDelegate> delegate;
    MKAnnotationViewDragState dragState;
}

@property (nonatomic, assign) id <MKMapViewDelegate> delegate;
@property (nonatomic, assign) MKAnnotationViewDragState dragState;
@property (nonatomic, assign) MKMapView *mapView;

@end

