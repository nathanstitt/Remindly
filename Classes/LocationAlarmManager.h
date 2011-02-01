//
//  LocationManager.h
//  Remindly
//
//  Created by Nathan Stitt on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h> 
#import "Note.h"

#define ALARM_METER_RADIUS 1000.0f

@interface LocationAlarmManager : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *manager;
	NSMutableDictionary *notes;
	CLLocation *lastLocation;
}

+ (void)startup;
+ (void)registerNote:(Note*)note;
+ (void)unregisterNote:(Note*)note;
+ (CLLocation*)lastCoord;
+ (NSString*)distanceStringFrom:(CLLocationCoordinate2D)coord;
@end
