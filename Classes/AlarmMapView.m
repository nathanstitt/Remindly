//
//  MapView.m
//  Remindly
//
//  Created by Nathan Stitt on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlarmMapView.h"
#import "AlarmViewController.h"

@implementation AlarmMapView

@synthesize map;

-(id)initWithAlarmView:(AlarmViewController*)view{
	self = [ super init ];
	if ( ! self ){
		return nil;
	}	
	map=[[MKMapView alloc] initWithFrame: view.childFrame ];
	map.mapType = MKMapTypeStandard;
	map.showsUserLocation = YES;
	
	map.delegate=self;

	CLLocationCoordinate2D coordinate;
	coordinate.latitude = 37.810000;
	coordinate.longitude = -122.477989;
	
	MKCoordinateRegion region;
	region.center = coordinate;
	region.span.longitudeDelta = 0.08;
	region.span.latitudeDelta  = 0.08;
	map.region = region;

	
	annotation = [[ AlarmAnnotation alloc ] init ];
		
	[ map addAnnotation: annotation ];
	[ map deselectAnnotation:annotation animated:NO ];
	[ map selectAnnotation:annotation animated:NO ];	
    return self;

}



- (void)dealloc {
	[ map release ];
    [super dealloc];
}

#pragma mark -
#pragma mark MKMapViewDelegate


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)a 
{
	
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
	} else {
		static NSString* alarmIdentifier = @"alarmIdentifier";

		MKAnnotationView* pinView = [mapView dequeueReusableAnnotationViewWithIdentifier:alarmIdentifier];
		if (!pinView) {
			pinView = [[[AlarmAnnotationView alloc]
											   initWithAnnotation:annotation reuseIdentifier:alarmIdentifier] autorelease];
			pinView.draggable = YES;
			pinView.canShowCallout = YES;
			
			UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure ];
            [rightButton addTarget:self
                            action:@selector(showDetails:)
                  forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = rightButton;
		}
		
		return pinView;
	}
	
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;{
	
//    DDAnnotation *anno = view.annotation;
    //access object via
//    [anno.objectX callSomeMethod];
}


@end
