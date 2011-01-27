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

@interface LocationAlarmManager : NSObject <CLLocationManagerDelegate,UIAlertViewDelegate> {

	CLLocationManager *manager;
	Note *pendingNote;
}

+ (void)startup;
+ (BOOL)registerNote:(Note*)note;
+ (BOOL)unregisterNote:(Note*)note;
+ (void)displayNoteAlarm:(Note*)note;

@end
