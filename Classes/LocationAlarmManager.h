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

#define ALARM_METER_RADIUS 500.0f

@interface LocationAlarmManager : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *manager;
	Note *pendingNote;
}

+ (void)startup;
+ (BOOL)registerNote:(Note*)note;
+ (BOOL)unregisterNote:(Note*)note;
+ (CLLocationCoordinate2D)lastCoord;

@end
