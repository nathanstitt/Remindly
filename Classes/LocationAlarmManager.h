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

#define ALARM_KM_RADIUS 0.5f

@interface LocationAlarmManager : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *manager;
	Note *pendingNote;
}

+ (void)startup;
+ (BOOL)registerNote:(Note*)note;
+ (BOOL)unregisterNote:(Note*)note;
+ (CLLocationCoordinate2D)lastCoord;
+ (NSString*)distanceStringFrom:(CLLocationCoordinate2D)coord;
@end
