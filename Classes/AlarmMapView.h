//
//  MapView.h
//  Remindly
//
//  Created by Nathan Stitt on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AlarmAnnotationPin.h"
#import "Note.h"

@class AlarmViewController;

@interface AlarmMapView : NSObject <MKMapViewDelegate,CLLocationManagerDelegate>{
	AlarmViewController *alarmView;
	MKMapView *map;
	MKCircle* circle;
	AlarmAnnotationPin *pin;
	BOOL dirty;
}

-(void) setFromNote:(Note*)note;
-(void) saveToNote: (Note*)note;
-(id)   initWithAlarmView:(AlarmViewController*)view;
-(void) didChangeDragState:(MKAnnotationViewDragState)newDragState fromOldState:(MKAnnotationViewDragState)dragState;
-(void) reset;

@property (readonly,nonatomic) UIView *view;
@property (readonly,nonatomic) MKMapView *map;

@end
