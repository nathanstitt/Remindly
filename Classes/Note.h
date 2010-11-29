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

-(id)initWithDirectoryName:(NSString*)file;
-(void)save;
-(BOOL)hasNotification;
-(void)setFireName:(NSString*)name minutes:(NSNumber*)minutes;
-(NSString*)alarmDescription;
-(void)scedule;
-(void)deleteFromDisk;

@property (readonly, nonatomic ) NSString *alarmName;
@property (readonly, nonatomic ) NSNumber *alarmMinutes;

@property (readonly, nonatomic ) NSDate *lastSave;
@property (readonly, nonatomic ) NSDate *dateCreated;
@property (retain,   nonatomic) UILocalNotification *notification;
@property (retain,   nonatomic) NSString *directory;
@property (retain,   nonatomic) UIImage *image;
@end
