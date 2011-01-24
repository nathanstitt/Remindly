//
//  MapView.h
//  Remindly
//
//  Created by Nathan Stitt on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AlarmAnnotationView.h"

@class AlarmViewController;

@interface AlarmMapView : NSObject <MKMapViewDelegate>{
	AlarmViewController *alarmView;
	MKMapView *map;
	AlarmAnnotation *annotation;
	AlarmAnnotationView *annotationView;
}

-(id)initWithAlarmView:(AlarmViewController*)view;

@property (readonly,nonatomic) MKMapView *map;

@end
