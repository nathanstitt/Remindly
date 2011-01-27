//
//  Note.m
/*  This file is part of Remindly.

    Remindly is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3.

    Remindly is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Remindly.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "Note.h"
#import "NSDate+HumanInterval.h"
#import "NotesManager.h"
#import "LocationAlarmManager.h"

@interface Note()
-(id)initWithDirectoryName:(NSString*)file;
@end

@implementation Note

@synthesize directory,image, notification,index;

static NSMutableDictionary *_cache;
+(void)	primeCache{
	_cache = [[ NSMutableDictionary alloc ] init ];
}

+(Note*)noteWithDirectory:(NSString*)d {
	Note *note = [ _cache objectForKey:d];
	if ( ! note ){
		note = [[ Note alloc ] initWithDirectoryName:d ];
		[ _cache setObject:note forKey: d ];
		[ note release ];
	}
	return note;
}

-(id)initWithDirectoryName:(NSString*)d{
    self = [super init ];
	if ( ! self ){
		return nil;
	}
	directory = d;
	[ directory retain ];
	
	plist = [ [ NSMutableDictionary alloc] initWithContentsOfFile: [ [ self fullDirectoryPath ] stringByAppendingPathComponent:@"info.plist" ] ];

	image = [ UIImage imageWithContentsOfFile: [ [ self fullDirectoryPath ] stringByAppendingPathComponent:@"image.png" ] ];
	
	[ image retain ];
	
	return self;
}

-(NSString*)fullDirectoryPath{
	return [ [ NotesManager instance ].path stringByAppendingPathComponent: self.directory ];
}

-(NSString*)alarmTitle{
	NSDate *fire = [ notification fireDate ];
	if ( fire ){
		return [ fire humanIntervalFromNow ];
	} else { 
		return @"alarm not set";
	}
}


-(void)setAlarmType:(NSString *)name {
	[plist setObject:name forKey:@"alarmType"];
}


-(NSString *) alarmType {
	return [ plist valueForKey:@"alarmType" ];
}

-(NSString *) alarmText {
	return [ plist valueForKey:@"alarmType" ];
}

-(NSDate*)fireDate{
	if ( [ self hasNotification ] ){
		return [ notification fireDate ];
	} else {
		return nil;
	}
}

-(void)setFireDate:(NSDate*)date{
	[ plist setValue: date forKey:@"fireDate" ];
}

-(void)unScedule {
	if ( notification ){
		[ [UIApplication sharedApplication] cancelLocalNotification: notification ];
	}
	[ LocationAlarmManager unregisterNote: self ];
}

-(void)removeSelf {
	NSFileManager *fm = [NSFileManager defaultManager];
	[ self unScedule ];
	[ fm removeItemAtPath: [ self fullDirectoryPath ] error:nil ];
	[ _cache removeObjectForKey: directory ];
}

- (NSNumber *) alarmMinutes {
	return [ plist valueForKey:@"alarmMinutes" ];
}

-(BOOL)hasNotification{
	return NULL != notification;
}

-(NSDate*)lastSave {
	return [ plist valueForKey: @"lastSave" ];
}

-(NSInteger)alarmTag {
	return [[ plist valueForKey:@"alarmTag" ] intValue ];
}

-(void)setAlarmTag:(NSInteger)tag {
	[ plist setObject:[ NSNumber numberWithInt: tag ] forKey:@"alarmTag" ];
}

-(void)save {
	[ plist setObject:[NSDate date] forKey:@"lastSave" ];
	[ plist writeToFile:[ [ self fullDirectoryPath ] stringByAppendingPathComponent:@"info.plist" ] atomically: YES ];
	[ UIImagePNGRepresentation(image) writeToFile:[ [ self fullDirectoryPath ] stringByAppendingPathComponent:@"image.png" ] atomically:YES];
	UIApplication *app = [UIApplication sharedApplication];
	[ self unScedule ];
	if ( ! notification ){
		notification = [[UILocalNotification alloc] init];
	}
		

	NSDate *fd = [ plist valueForKey: @"fireDate" ];
	if ( 2 == [ self alarmTag ] ){
		[ LocationAlarmManager registerNote: self ];
		
	} else if ( [ fd timeIntervalSinceNow ] > 0 ){

		notification.fireDate = fd;
		notification.timeZone = [NSTimeZone defaultTimeZone];
		notification.alertBody =  [ NSString stringWithFormat:@"%@\n%@",@"IT'S TIME!", self.alarmText ];
		notification.alertLaunchImage = [ [ self fullDirectoryPath ] stringByAppendingPathComponent:@"image.png" ];
		notification.alertAction = @"View Note";
		notification.soundName = UILocalNotificationDefaultSoundName;
		notification.applicationIconBadgeNumber = 1;
		
		NSDictionary *infoDict = [NSDictionary dictionaryWithObject: self.directory forKey:@"directory"];
		notification.userInfo = infoDict;
		[ app scheduleLocalNotification:notification ];
	}

}


// set coordinate and entering/leaving geo based alarm
-(void)setCoordinate:(CLLocationCoordinate2D)coordinate onEnterRegion:(BOOL)enter{
	[ plist setValue:[ NSNumber numberWithDouble: coordinate.latitude  ] forKey:@"latitude"  ];
	[ plist setValue:[ NSNumber numberWithDouble: coordinate.longitude ] forKey:@"longitude" ];
	[ plist setValue:[ NSNumber numberWithBool:enter ] forKey: @"onEnterRegion" ];
}

-(BOOL)onEnterRegion{
	return [ [ plist valueForKey:@"onEnterRegion" ] boolValue ];
}

-(CLLocationCoordinate2D)coordinate{
	CLLocationCoordinate2D coord;
	coord.longitude = [[plist valueForKey:@"longitude"] doubleValue ];
	coord.latitude  = [[plist valueForKey:@"latitude"]  doubleValue ];
	return coord;
}



-(void)setImage:(UIImage*)img{
	if ( image != img ){
		[ image release ];
		[ img retain ];
		image = img;
		[UIImagePNGRepresentation(image) writeToFile:[ [ self fullDirectoryPath ] stringByAppendingPathComponent:@"image.png" ] atomically:YES];
	}
}

- (void)dealloc {
	if ( notification ){
		[ [ UIApplication sharedApplication] cancelLocalNotification: notification ];
		[ notification release];
	}
	[ directory    release ];
	[ image release ];
	[ plist release ];
    [ super dealloc ];
}
@end
