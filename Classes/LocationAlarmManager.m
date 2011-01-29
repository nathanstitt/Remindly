//
//  LocationManager.m
//  Remindly
//
//  Created by Nathan Stitt on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationAlarmManager.h"
#import "NotesManager.h"


LocationAlarmManager *instance;

@interface LocationAlarmManager()
-(void)startMonitor;
@property (nonatomic,retain) CLLocationManager *manager;
@property (nonatomic,retain) Note *pendingNote;
@end

@implementation LocationAlarmManager

@synthesize manager,pendingNote;

+ (void)startup {
    // Create the location manager if this object does not
    // already have one.
	
    if ( ! instance ){
		instance = [[ LocationAlarmManager alloc ] init ];
	} else {
		instance.startMonitor;
	}
}

-(void)startMonitor {
    [ manager startMonitoringSignificantLocationChanges];
	
}
-(id) init {
	self = [ super init ];
	if ( ! self ){
		return nil;
	}
	self.manager = [[CLLocationManager alloc] init];
	manager.purpose = @"In order to use geographical alarms that alert you when leaving or entering an area";
    manager.delegate = self;
	[ manager startUpdatingLocation ];

	[ manager release ];

	for ( CLRegion *region in [ instance.manager monitoredRegions ] ){
		NSLog(@"Region alert %d,%d at %@" , 
			  region.center.longitude, 
			  region.center.latitude, 
			  region.identifier );
	};


	return self;
}

-(void)displayAlert:(NSString*)text {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alarm expired"
											message: text
											delegate:self 
											cancelButtonTitle:@"Cancel" otherButtonTitles:@"View",NULL];
	[alert show];
	[alert release];		
}

-(void)displayNoteAlarm:(Note*)note {
	self.pendingNote = note;
	
	UILocalNotification *notification = [[UILocalNotification alloc] init];

	notification.fireDate =  [ NSDate date ];
	notification.timeZone =  [ NSTimeZone defaultTimeZone];
	notification.alertBody = [ NSString stringWithFormat:@"Location %@\n%@", 
							   note.onEnterRegion ? @"Reached" : @"Left",
							   note.alarmText ];
	notification.alertLaunchImage = [ [ note fullDirectoryPath ] stringByAppendingPathComponent:@"image.png" ];
	notification.alertAction = @"View Note";
	notification.soundName = UILocalNotificationDefaultSoundName;
	notification.applicationIconBadgeNumber = 1;
	
}



-(void)dealloc {
	[ [ NSNotificationCenter defaultCenter] removeObserver:self];
	
	[ manager release ];
	[ super dealloc ];
}


+ (BOOL)unregisterNote:(Note*)note{
	for ( CLRegion *region in [ instance.manager monitoredRegions ] ){
		Note *note = [ [NotesManager instance] noteWithDirectory: region.identifier ];
		if ( note ){
			[ instance.manager stopMonitoringForRegion:region ];
			return YES;
		}
	};
	return NO;
}

+(CLLocationCoordinate2D)lastCoord{
	return instance.manager.location.coordinate;
}

+ (BOOL)registerNote:(Note*)note {

   // Do not create regions if support is unavailable or disabled.
   if ( ![CLLocationManager regionMonitoringAvailable] ||
        ![CLLocationManager regionMonitoringEnabled] )
      return NO;

	CLLocationDegrees radius = ALARM_METER_RADIUS;
 
	// Create the region and start monitoring it.
	CLRegion* region = [[CLRegion alloc] initCircularRegionWithCenter: note.coordinate
                        radius:radius identifier: note.directory ];
	
	[ instance.manager startMonitoringForRegion:region desiredAccuracy:1000.0f];

	[region release];
	return YES;
}



#pragma mark -
#pragma mark CLLocationManager delegate methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"Location Manager error: %@", [error description] );
	
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	[[ NSNotificationCenter defaultCenter ] postNotificationName:@"locationUpdated" object: newLocation ];
}

- (void)locationManager:(CLLocationManager *)m didEnterRegion:(CLRegion *)region{
	NSLog(@"-----------------------> Location Manager Entered: %@", region.identifier );
	Note *note = [ [NotesManager instance] noteWithDirectory: region.identifier ];
	if ( note && note.onEnterRegion ){
		[ self displayNoteAlarm:note ];
	}
	[ m stopMonitoringForRegion:region ];
}

- (void)locationManager:(CLLocationManager *)m didExitRegion:(CLRegion *)region{
	NSLog(@"-----------------------> Location Manager Exited: %@", region.identifier );

	Note *note = [ [NotesManager instance] noteWithDirectory: region.identifier ];
	if ( note && ! note.onEnterRegion ){
		[ self displayNoteAlarm:note ];
	}
	[ m stopMonitoringForRegion:region ];
}


@end
