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
#import "Appirater.h"

@implementation NoteTextBlob

@synthesize text,frame,note;

-(id)initWithNote:(Note*)n {
	self = [ super init ];
	text = [ NSString string ];
	[text retain ];
	note = n;
	return self;
}

-(id)initWithCoder:(NSCoder*)coder{
	self  = [ super init ];
	text  = [ coder decodeObjectForKey:@"text" ];
	[ text retain ];
	frame = [ coder decodeCGRectForKey:@"frame" ];
	return self;
}
-(void)remove {
	[ note removeTextBlob: self ];
}
-(void)encodeWithCoder:(NSCoder*)coder{
	[ coder encodeObject:text forKey:@"text"];
	[ coder encodeCGRect: frame forKey:@"frame"];
	
}
-(void)dealloc {
	[ text release ];
	[ super dealloc ];
}
@end


@interface Note()
-(id)initWithDirectoryName:(NSString*)file;
@end

@implementation Note

@synthesize directory,image, notification,index,textBlobs=texts;

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
	texts = [ [ NSMutableArray alloc ] init ];
	for ( NSData *data in [ plist objectForKey:@"texts" ] ){
		NoteTextBlob *ntb = [ NSKeyedUnarchiver unarchiveObjectWithData: data ] ;
		ntb.note = self;
		[texts addObject: ntb ];
	}
	return self;
}

-(NSString*)fullDirectoryPath{
	return [ [ NotesManager instance ].path stringByAppendingPathComponent: self.directory ];
}

-(NoteTextBlob*)addTextBlob{
	NoteTextBlob* ntb = [[ NoteTextBlob alloc ] initWithNote:self ];
	[texts addObject:ntb ];
	[ ntb release ];
	return ntb;
}


-(void)removeTextBlob:(NoteTextBlob*)ntb{
	[texts removeObjectIdenticalTo:ntb ]; 
}


-(NSString*)alarmTitle{
	NSDate *fire = [ notification fireDate ];
	NSInteger tag = [ self alarmTag ];
	if ( [ self hasCoordinate ] && 2 == tag ){
		return [ NSString stringWithFormat:@"%@ %@ from here", 
				[ self onEnterRegion ] ? @"Entering" : @"Exiting",
				[ LocationAlarmManager distanceStringFrom: [ self coordinate ] isEnter: [ self onEnterRegion ] ]
				];
	} else if ( fire ) {
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


NSComparisonResult
compareByPosition(NoteTextBlob *ntb1, NoteTextBlob *ntb2, void *context) {
	return [ [ NSNumber numberWithInt: ntb1.frame.origin.y]  compare: [ NSNumber numberWithInt: ntb2.frame.origin.y ] ];
}


-(NSString *) alarmText {
    NSMutableArray *nms = [ NSMutableArray array ];
    for ( NoteTextBlob *ntb in [ texts sortedArrayUsingFunction: compareByPosition context:NULL ] ){
        [ nms addObject: ntb.text ];
    }
	return [ nms componentsJoinedByString:@"\n" ];
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

-(BOOL)hasCoordinate {
	return ( nil != [plist valueForKey:@"longitude"] );
}

-(NoteAlarmType)alarmTag {
	return [[ plist valueForKey:@"alarmTag" ] intValue ];
}

-(void)setAlarmTag:(NoteAlarmType)tag {
	[ plist setObject:[ NSNumber numberWithInt: tag ] forKey:@"alarmTag" ];
}

-(NoteSoundType)soundTag {
	return [[ plist valueForKey:@"soundTag" ] intValue ];
}

-(void)setSoundTag:(NoteSoundType)tag {
	[ plist setObject:[ NSNumber numberWithInt: tag ] forKey:@"soundTag" ];
}

-(void)save {
	NSString *dir = [ self fullDirectoryPath ];

	if ( ! notification ){
		notification = [[UILocalNotification alloc] init];
	}
	NSMutableArray *data = [[ NSMutableArray alloc ] init ];
	for ( NoteTextBlob *tb in texts ){
		[ data addObject: [ NSKeyedArchiver archivedDataWithRootObject:tb] ];
	}

	[ plist setObject: data forKey:@"texts" ];
	[ data release ];
	[ plist writeToFile:[ dir stringByAppendingPathComponent:@"info.plist" ] atomically: YES ];
}

-(void)unScedule {
	if ( notification ){
		[ [UIApplication sharedApplication] cancelLocalNotification: notification ];
	}
    NSLog(@"Unscedule note from note class");
    if ( [ self hasCoordinate ] ){
        [ LocationAlarmManager unregisterNote: self ];
        [ plist removeObjectForKey:@"longitude" ];
        [ plist removeObjectForKey:@"latitude" ];
        if ( notification ){
            notification.fireDate = [ NSDate date ];
        }
    } 
    
}
-(NSString*)soundPath {
    NSString *snd;
    if ( SOUND_SYSTEM_DEF_TYPE == self.soundTag ){
        return nil;
    }
     if ( SOUND_VOICE_TYPE == self.soundTag ){
            if ( [self hasCoordinate ] && 2 == [ self alarmTag ] ){ 
                snd = [ self onEnterRegion ] ? @"alarm-area-entered.caf" : @"alarm-area-departed.caf";
            } else {
                if ( ALARM_QUICK_TIME_TYPE == self.alarmTag ){
                    NSDictionary *times = [ [ NSDictionary alloc] initWithContentsOfFile:
                               [ [ [ NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"alarm_times.plist"] ];
                    snd = [ NSString stringWithFormat:@"v%@.caf", [ times objectForKey: self.alarmType ] ];
                    [ times release ];
                } else {
                    snd = @"its-time.caf";
                }
            }
    } else {
        snd = [ NSString stringWithFormat:@"%d.caf", self.soundTag ];
    }
    return snd;
}

-(void)scedule {
    [Appirater userDidSignificantEvent:YES];
    
	NSDate *fd = [ plist valueForKey: @"fireDate" ];
    
	if ( [self hasCoordinate ] && 2 == [ self alarmTag ] ){
		[ LocationAlarmManager registerNote: self ];
       
	} else if ( [ fd timeIntervalSinceNow ] > 0 ){
		if ( notification ){
			[ [UIApplication sharedApplication] cancelLocalNotification: notification ];
		}
		notification.fireDate = [ fd timeIntervalSinceNow ] <= 600 ? fd : [ fd dateByAddingTimeInterval: 2 ];
		notification.timeZone = [NSTimeZone defaultTimeZone];
		notification.alertBody =  [ NSString stringWithFormat:@"IT'S TIME!\n%@\n%@", 
                                   self.alarmType,
                                   self.alarmText ];
        NSLog(@"Added Alarm:\n%@",notification.alertBody);
		notification.alertAction = @"View Note";
        NSString *snd = [self soundPath ];
		notification.soundName =  snd ? snd : UILocalNotificationDefaultSoundName;
		notification.applicationIconBadgeNumber = 1;

		NSDictionary *infoDict = [NSDictionary dictionaryWithObject: self.directory forKey:@"directory"];
		notification.userInfo = infoDict;
		[ [UIApplication sharedApplication] scheduleLocalNotification:notification ];
	}

}


-(void)setThumbnail:(UIImage*)tn{
	if ( thumbnail != tn ){
		[ thumbnail release ];
		thumbnail = [ tn retain ];
	}
	[ UIImagePNGRepresentation(thumbnail) writeToFile:[ [ self fullDirectoryPath ] stringByAppendingPathComponent:@"thumbnail.png" ] atomically:YES];
}


-(UIImage*)thumbnail {
	if ( ! thumbnail ){
		thumbnail = [ UIImage imageWithContentsOfFile: [ [ self fullDirectoryPath ] stringByAppendingPathComponent:@"thumbnail.png" ] ];
		[ thumbnail retain ];
	}
	return thumbnail;
}


-(void)setImage:(UIImage*)img{
	if ( image != img ){
		[ image release ];
		image = [ img retain ];
	}
	[ UIImagePNGRepresentation(image) writeToFile:[ [ self fullDirectoryPath ] stringByAppendingPathComponent:@"image.png" ] atomically:YES];
}

-(UIImage*)image {
	if ( ! image ){
		image = [ UIImage imageWithContentsOfFile: [ [ self fullDirectoryPath ] stringByAppendingPathComponent:@"image.png" ] ];
		[ image retain ];
	}
	return image;
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

-(CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coord;
	coord.longitude = [[plist valueForKey:@"longitude"] doubleValue ];
	coord.latitude  = [[plist valueForKey:@"latitude"]  doubleValue ];
	return coord;
}




- (void)dealloc {
	if ( notification ){
		[ [ UIApplication sharedApplication] cancelLocalNotification: notification ];
		[ notification release];
	}
    [ thumbnail release ];
	[ directory release ];
	[ image     release ];
	[ plist     release ];
    [ super     dealloc ];
}
@end
