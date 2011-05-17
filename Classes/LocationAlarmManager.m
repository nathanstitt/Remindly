//
//  LocationManager.m
//  Remindly
//
//  Created by Nathan Stitt on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationAlarmManager.h"
#import "NotesManager.h"
#import <MapKit/MapKit.h>

LocationAlarmManager *instance;

@interface LocationAlarmManager()
-(void)startOrStopMonitor;
@property (nonatomic,retain) CLLocationManager *manager;
@property (nonatomic,readonly) NSMutableDictionary *notes;
@property (nonatomic,retain ) CLLocation *lastLocation;
@end

@implementation LocationAlarmManager

@synthesize manager, notes, lastLocation;

+ (void)startup {
    if ( ! instance ){
		instance = [[ LocationAlarmManager alloc ] init ];
	} else {
		[ instance startOrStopMonitor ];
	}
}

-(void)startOrStopMonitor {
	NSLog(@"startOrStopMonitor");
	manager.delegate = self;
    manager.distanceFilter = ALARM_METER_RADIUS / 0.1;
    if ( [notes count] ){
        NSLog(@"startOrStopMonitor -> started monitor");
        [ manager startMonitoringSignificantLocationChanges];
    } else {
        NSLog(@"startOrStopMonitor -> stopped monitor");
        [ manager stopMonitoringSignificantLocationChanges ];
    }
}

-(id) init {
	self = [ super init ];
	if ( ! self ){
		return nil;
	}
	notes = [[ NSMutableDictionary alloc ] init ];
	for ( Note *note in [ NotesManager notesWithLocationAlarms ] ){
		[ notes setObject: note forKey: note.directory ];
	}
    
	self.manager = [[CLLocationManager alloc] init];
	manager.purpose = @"In order to use geographical alarms that alert you when leaving or entering an area";
    manager.delegate = self;
	[ manager release ];
    [ self startOrStopMonitor ];
    
	return self;
}


-(void)fireNoteAlarm:(Note*)note {
	UILocalNotification *notification = [[UILocalNotification alloc] init];

	notification.fireDate =  [ NSDate date ];
	notification.timeZone =  [ NSTimeZone defaultTimeZone];
	notification.alertBody = [ NSString stringWithFormat:@"Location %@\n%@", 
							   note.onEnterRegion ? @"Reached" : @"Left",
							   note.alarmText ];

	notification.alertAction = @"View Note";
    NSString *snd = [ note soundPath ];
    notification.soundName =  snd ? snd : UILocalNotificationDefaultSoundName;    
	notification.applicationIconBadgeNumber = 1;

    NSDictionary *infoDict = [NSDictionary dictionaryWithObject: note.directory forKey:@"directory"];
    notification.userInfo = infoDict;

    [ note unScedule ];

	[ [UIApplication sharedApplication] presentLocalNotificationNow:notification ];
	[ notification release ];
}



-(void)dealloc {
	[ [ NSNotificationCenter defaultCenter] removeObserver:self];
	[ notes   release ];
	[ manager release ];
	[ super dealloc ];
}


+(void)unregisterNote:(Note*)note{
	[ instance.notes removeObjectForKey: note.directory ];
    [ instance startOrStopMonitor ];
}


+(CLLocation*)lastCoord {
	return instance.manager.location;
}


+ (void)registerNote:(Note*)note {
	[ instance.notes setObject:note forKey:note.directory ];
    [ instance startOrStopMonitor ];    
}


// returns a string if the number with one decimal place of precision
// sets the style (commas or periods) based on the locale
NSString * formatDecimal_1(NSNumber *num) {
	static NSNumberFormatter *numFormatter;
	if (!numFormatter) {
		numFormatter = [[[NSNumberFormatter alloc] init] retain];
		[numFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[numFormatter setLocale:[NSLocale currentLocale]];
		[numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[numFormatter setMaximumFractionDigits:1];
		[numFormatter setMinimumFractionDigits:1];
	}
	return [numFormatter stringFromNumber: num ];
}

+ (NSString*)distanceStringFrom:(CLLocationCoordinate2D)coord isEnter:(BOOL)isEnter {
	double distance = MKMetersBetweenMapPoints( MKMapPointForCoordinate( coord ),
					  MKMapPointForCoordinate( [ LocationAlarmManager lastCoord ].coordinate ) );

    if ( isEnter ){
        distance = MAX( distance - ALARM_METER_RADIUS , 0 );
    } else {
        distance = (ALARM_METER_RADIUS*1.5) - distance;
    }

	NSString * unitName;
	NSString *locale = [ [ NSLocale currentLocale ] localeIdentifier ];
    
	if ( [ locale isEqual:@"en_US" ]) {
		unitName = @"mi";
		distance = distance / 1609.344;
	} else {
		unitName = @"km";
		distance = distance / 1000;
	}
    
	return [NSString stringWithFormat:@"%@ %@", formatDecimal_1( [NSNumber numberWithDouble: distance] ), unitName ];
}

#pragma mark -
#pragma mark CLLocationManager delegate methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"Location Manager error: %@", [error description] );
	
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    //NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];

    if ( ! [ notes count ]) return;

    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;


    for ( Note *note in [ notes allValues ] ){
        double distance = MKMetersBetweenMapPoints( MKMapPointForCoordinate( newLocation.coordinate ),
                                                 MKMapPointForCoordinate( note.coordinate ) );
        
        if ( ( ( distance + newLocation.horizontalAccuracy ) < ALARM_METER_RADIUS && note.onEnterRegion )
            ||
             ( ( distance - newLocation.horizontalAccuracy ) > ( ALARM_METER_RADIUS * 1.5 ) && ! note.onEnterRegion ) ) 
        {
            NSLog(@"Firing %@ Alarm: %f %f distance: %f accuracy %f", 
                  note.onEnterRegion ? @"Enter" : @"Exit",
                  note.coordinate.latitude, 
                  note.coordinate.longitude,
                  distance, distance );
            [ self fireNoteAlarm:note ];
        }
    }
    

}

// this sucks balls, terribly inaccurate, alarms only fire about 1/3 of the time

//- (void)locationManager:(CLLocationManager *)m didEnterRegion:(CLRegion *)region{
//	NSLog(@"-----------------------> Location Manager Entered: %@", region.identifier );
//	Note *note = [ [NotesManager instance] noteWithDirectory: region.identifier ];
//	if ( note ){ //&& note.onEnterRegion ){
//		[ self displayNoteAlarm:note ];
//	}
////	[ m stopMonitoringForRegion:region ];
//}
//
//- (void)locationManager:(CLLocationManager *)m didExitRegion:(CLRegion *)region{
//	NSLog(@"-----------------------> Location Manager Exited: %@", region.identifier );
//
//	Note *note = [ [NotesManager instance] noteWithDirectory: region.identifier ];
//	if ( note ){// && ! note.onEnterRegion ){
//		[ self displayNoteAlarm:note ];
//	}
////	[ m stopMonitoringForRegion:region ];
//}


@end
