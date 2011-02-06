//
//  MapView.m
//  Remindly
//
//  Created by Nathan Stitt on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlarmMapView.h"
#import "AlarmViewController.h"
#import "LocationAlarmManager.h"
#import "ToggleButton.h"

@interface AlarmMapView()
@property (nonatomic,retain) MKCircle* circle;
@end

@implementation AlarmMapView

@synthesize  map, circle;

-(id)initWithAlarmView:(AlarmViewController*)view{
	self = [ super init ];
	if ( ! self ){
		return nil;
	}
	

	map = [[MKMapView alloc] initWithFrame: view.childFrame ];
	map.mapType = MKMapTypeStandard;
	map.showsUserLocation = YES;

	map.delegate=self;


	pin = [[ AlarmAnnotationPin alloc ] initWithMap:self ];
	[ map addAnnotation: pin.annotation ];
	
	self.circle = [MKCircle circleWithCenterCoordinate: map.userLocation.coordinate radius:1000];
	[map addOverlay:circle];

	[ self.map.userLocation addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)  
           context:NULL];
	
	// [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:@"locationUpdated" object:nil];

    return self;

}


-(void)moveTo:(CLLocationCoordinate2D)coord {
    pin.onEnter = NO;
	pin.annotation.coordinate = coord;
	MKCoordinateRegion region;
	region.center = coord;
	region.span.longitudeDelta = 0.08;
	region.span.latitudeDelta  = 0.08;
	map.region = region;
	if ( ! map.selectedAnnotations.count ){
		[ map selectAnnotation:pin.annotation animated:YES ];	
	}
	[ map removeOverlays:[map overlays ]];

	self.circle = [MKCircle circleWithCenterCoordinate: pin.annotation.coordinate radius:1000];
	[map addOverlay:self.circle];
}


-(void)observeValueForKeyPath:(NSString *)keyPath  ofObject:(id)object change:(NSDictionary *)change  context:(void *)context {  
	if (! dirty && self.map.userLocation.location ){
		[ self moveTo: self.map.userLocation.location.coordinate ];
	}
}


-(void) reset {
	dirty = NO;
    if ( map.userLocation.location ){
        [ self moveTo: map.userLocation.location.coordinate ];
    }
}


-(UIView*)view {
	return map;
}


-(void)setFromNote:(Note*)note{
	if ( [ note hasCoordinate ] ){
		dirty = YES;
		[ self moveTo: note.coordinate ];
		pin.onEnter = note.onEnterRegion;
	}
}


-(void)saveToNote:(Note*)note{
	note.alarmType = @"Geographical Region";
	[ note setCoordinate: pin.annotation.coordinate onEnterRegion: pin.onEnter ];
}


- (void)dealloc {
	[ circle release ];
	[ map release ];
    [super dealloc];
}


#pragma mark -
#pragma mark CLLocationManagerDelegate


-(void)onLocationUpdate:(NSNotification*)n {
	if (! dirty ){
		[ self moveTo: ((CLLocation*)n.object).coordinate ];
	}
}


#pragma mark -
#pragma mark MKMapViewDelegate

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay{
	MKCircleView* circleView = [[MKCircleView alloc] initWithOverlay:overlay];
	circleView.strokeColor = [UIColor darkGrayColor];
	circleView.lineWidth = 1.0;
	circleView.fillColor = [UIColor lightGrayColor];
	circleView.alpha= 0.6f;
	return [ circleView autorelease ];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)a  {
    if ([ a isKindOfClass:[MKUserLocation class]]){
        return nil;
	} else {
        return pin;
	}
}

-(void) didChangeDragState:(MKAnnotationViewDragState)newDragState fromOldState:(MKAnnotationViewDragState)dragState{
	dirty = YES;
	if ( MKAnnotationViewDragStateStarting == newDragState ){
		[ map removeOverlays:[map overlays ]];
	} else if (  MKAnnotationViewDragStateEnding == newDragState || MKAnnotationViewDragStateCanceling == newDragState ){
		self.circle = [MKCircle circleWithCenterCoordinate: pin.annotation.coordinate radius:1000];

		pin.onEnter = ! ( ALARM_METER_RADIUS > MKMetersBetweenMapPoints(MKMapPointForCoordinate( pin.annotation.coordinate ),
												 MKMapPointForCoordinate( map.userLocation.location.coordinate ) ) );

		[ map addOverlay:self.circle ];
		[ map selectAnnotation: pin.annotation animated:YES ];	
	}
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
