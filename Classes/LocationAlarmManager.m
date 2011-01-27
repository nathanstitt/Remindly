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
	manager.purpose = @"Alarms when reaching or leaving an area";
    manager.delegate = self;
	[ manager startUpdatingLocation ];

	[ manager release ];

	for ( CLRegion *region in [ instance.manager monitoredRegions ] ){
		NSLog(@"Region alert %d,%d at %@" , 
			  region.center.longitude, 
			  region.center.latitude, 
			  region.identifier );
	};

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNoteGeoAlarm:) name:@"NoteGeoAlarm" object:nil];

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
	[ self displayAlert: note.alarmText ];
}

+(void)displayNoteAlarm:(Note*)note {
	[ instance displayNoteAlarm:note ];
}

-(void)onNoteGeoAlarm:(NSNotification*)notif{
	[ self displayNoteAlarm: (Note*)notif.object ];
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

+ (BOOL)registerNote:(Note*)note {

   // Do not create regions if support is unavailable or disabled.
   if ( ![CLLocationManager regionMonitoringAvailable] ||
        ![CLLocationManager regionMonitoringEnabled] )
      return NO;

	// just use the largest radius possible
	CLLocationDegrees radius = 10.0f;
	
 
	// Create the region and start monitoring it.
	CLRegion* region = [[CLRegion alloc] initCircularRegionWithCenter: note.coordinate
                        radius:radius identifier: note.directory ];
	
	[ instance.manager startMonitoringForRegion:region desiredAccuracy:10.0f];
 	for ( CLRegion *region in [ instance.manager monitoredRegions ] ){
		NSLog(@"Region alert %d,%d at %@" , 
			  region.center.longitude, 
			  region.center.latitude, 
			  region.identifier );
	};
	[region release];
	return YES;
}

#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if ( buttonIndex ){
		[[ NSNotificationCenter defaultCenter ] postNotificationName:@"DisplayNote" object: self.pendingNote ];
	}
	self.pendingNote = nil;
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
	NSLog(@"Location Manager Entered: %@", region.identifier );
	[self displayAlert:[NSString stringWithFormat:@"Location Manager Enter: %@", region.identifier ] ];

//	Note *note = [ [NotesManager instance] noteWithDirectory: region.identifier ];
//	if ( note && note.onEnterRegion ){
//		[ self displayNoteAlarm:note ];
//	}
	[ m stopMonitoringForRegion:region ];
}

- (void)locationManager:(CLLocationManager *)m didExitRegion:(CLRegion *)region{
	NSLog(@"Location Manager Exited: %@", region.identifier );
	[self displayAlert:[NSString stringWithFormat:@"Location Manager Exit: %@", region.identifier ] ];
//	Note *note = [ [NotesManager instance] noteWithDirectory: region.identifier ];
//	if ( note && ! note.onEnterRegion ){
//		[ self displayNoteAlarm:note ];
//	}
	[ m stopMonitoringForRegion:region ];
}


@end
