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

@class AlarmPopUpController;

@interface AlarmMapView : NSObject <MKMapViewDelegate,CLLocationManagerDelegate>{
	AlarmPopUpController *alarmView;
	MKMapView *map;
	MKCircle* circle;
	AlarmAnnotationPin *pin;
	BOOL dirty;
}

-(id)   initWithAlarmView:(AlarmPopUpController*)view frame:(CGRect)frame;
-(void) setFromNote:(Note*)note;
-(void) saveToNote: (Note*)note;
-(void) didChangeDragState:(MKAnnotationViewDragState)newDragState fromOldState:(MKAnnotationViewDragState)dragState;
-(void) reset;

@property (readonly,nonatomic) UIView *view;
@property (readonly,nonatomic) MKMapView *map;

@end
