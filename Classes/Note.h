//
//  Note.h
//  IoGee
//
//  Created by Nathan Stitt on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Note : NSObject {
	NSMutableDictionary *plist;
	UIImage *image;
	NSString *directory;
	UILocalNotification *notification;
}

+(Note*)noteWithDirectory:(NSString*)dir;

-(void)save;
-(BOOL)hasNotification;
-(NSString*)alarmDescription;
-(void)scedule;
-(void)deleteFromDisk;

@property (assign,  nonatomic ) NSString *alarmName;
@property (assign,   nonatomic ) NSDate *fireDate;
//@property (readonly, nonatomic ) NSNumber *alarmMinutes;
//@property (readonly, nonatomic ) NSDate *lastSave;
@property (readonly, nonatomic ) NSDate *dateCreated;
@property (retain,   nonatomic) UILocalNotification *notification;
@property (retain,   nonatomic) NSString *directory;
@property (retain,   nonatomic) UIImage *image;
@end
