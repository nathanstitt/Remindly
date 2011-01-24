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

@synthesize  map, annotation;

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
//	annotationView = 
	
	circle = [MKCircle circleWithCenterCoordinate: coordinate radius:1000];
	[map addOverlay:circle];
	
	[ map addAnnotation: annotation ];
	[ self popUpCallOut ];
    return self;

}

-(UIView*)view {
	return map;
}

-(void)popUpCallOut {
	[ map deselectAnnotation:annotation animated:NO ];
	[ map selectAnnotation:annotation animated:YES ];	
}

- (void)dealloc {
	[ map release ];
    [super dealloc];
}

#pragma mark -
#pragma mark MKMapViewDelegate

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay{
      MKCircleView* circleView = [[[MKCircleView alloc] initWithOverlay:overlay] autorelease];

      circleView.strokeColor = [UIColor darkGrayColor];
      circleView.lineWidth = 1.0;
      //Uncomment below to fill in the circle
      circleView.fillColor = [UIColor lightGrayColor];
	circleView.alpha= 0.6f;
      return circleView;
 }

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)a 
{
	
    // if it's the user location, just return nil.
    if ([ a isKindOfClass:[MKUserLocation class]]){
        return nil;
	} else {
		//static NSString* alarmIdentifier = @"alarmIdentifier";

//		MKAnnotationView* pinView = [mapView dequeueReusableAnnotationViewWithIdentifier:alarmIdentifier];
		if (!annotationView) {
			annotationView = [ [ AlarmAnnotationView alloc ] initWithMap:self ];

//			pinView = [[AlarmAnnotationView alloc]  initWithAnnotation:a 
//													reuseIdentifier:@"alarmIdentifier"] ;
		}
		//pinView.annotation = a;
		return annotationView;
	}
	
}

-(void) didChangeDragState:(MKAnnotationViewDragState)newDragState fromOldState:(MKAnnotationViewDragState)dragState{
	
	// circle.coordinate = annotation.coordinate;
}

-(void)setHidden:(BOOL)v{
	map.hidden = v;
}

-(BOOL)hidden {
	return map.hidden;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;{
	
//    DDAnnotation *anno = view.annotation;
    //access object via
//    [anno.objectX callSomeMethod];
}


@end
