//
//  Note.m
//  IoGee
//
//  Created by Nathan Stitt on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Note.h"
#import "NSDate+HumanInterval.h"

@interface Note()
-(id)initWithDirectoryName:(NSString*)file;
@end


@implementation Note

@synthesize directory,image, notification;

static NSMutableDictionary *_cache;

+(Note*)noteWithDirectory:(NSString*)d {
	Note *note = [ _cache objectForKey:d];
	if ( ! note ){
		note = [[ Note alloc ] initWithDirectoryName:d ];
		[ _cache setObject:note forKey: d ];
	}
	return note;
}

-(id)initWithDirectoryName:(NSString*)d{
    self = [super init ];
	self.directory = d;
	NSLog(@"path=%@",[ directory stringByAppendingPathComponent:@"info.plist" ] );
	
	plist = [ [ NSMutableDictionary alloc] initWithContentsOfFile: [ directory stringByAppendingPathComponent:@"info.plist" ] ];
	if ( ! [ plist valueForKey:@"dateCreated" ] ){
		[ plist setObject:[NSDate date] forKey:@"dateCreated" ];
	}
	image = [ UIImage imageWithContentsOfFile: [ directory stringByAppendingPathComponent:@"image.png" ] ];
	
	[ image retain ];
	
	return self;
}


-(NSString*)alarmDescription{
	NSDate *fire = [ notification fireDate ];
	if ( fire ){
		return [ fire humanIntervalFromNow ];
	} else { 
		return @"alarm not set";
	}
}


-(void)setAlarmName:(NSString *)name {
	[plist setObject:name forKey:@"alarmName"];
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
}

-(void)deleteFromDisk {
	NSFileManager *fm = [NSFileManager defaultManager];
	[ self unScedule ];
	[ fm removeItemAtPath: directory error:NULL ];
	[ _cache removeObjectForKey: directory ];
}

-(NSString *) alarmName {
	return [ plist valueForKey:@"alarmName" ];
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

-(NSDate*)dateCreated {
	return [ plist valueForKey: @"dateCreated" ];
}

-(void)save {
	[ plist setObject:[NSDate date] forKey:@"lastSave" ];
	[ plist writeToFile:[ directory stringByAppendingPathComponent:@"info.plist" ] atomically: YES ];
	[ UIImagePNGRepresentation(image) writeToFile:[ directory stringByAppendingPathComponent:@"image.png" ] atomically:YES];
}


-(void)scedule {
	UIApplication *app = [UIApplication sharedApplication];
	[ self unScedule ];
	if ( ! notification ){
		notification = [[UILocalNotification alloc] init];
	}
	NSDate *fd = [ plist valueForKey: @"fireDate" ];
	if ( [ fd timeIntervalSinceNow ] > 0 ){
		
	}
	notification.fireDate = fd;
	notification.timeZone = [NSTimeZone defaultTimeZone];
	notification.alertBody =  [ NSString stringWithFormat:@"%@\n%@",@"IT'S TIME!", self.alarmName ];
	notification.alertLaunchImage = [ directory stringByAppendingPathComponent:@"image.png" ];
	notification.alertAction = @"View Note";
	notification.soundName = UILocalNotificationDefaultSoundName;
	notification.applicationIconBadgeNumber = 1;

	NSDictionary *infoDict = [NSDictionary dictionaryWithObject: directory forKey:@"directory"];
	notification.userInfo = infoDict;
	[ app scheduleLocalNotification:notification ];
	
	
	
}


-(void)setImage:(UIImage*)img{
	if ( image != img ){
		[ image release ];
		[ img retain ];
		image = img;
		[UIImagePNGRepresentation(image) writeToFile:[ directory stringByAppendingPathComponent:@"image.png" ] atomically:YES];
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
