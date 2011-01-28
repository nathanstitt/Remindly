//
//  Created by Nathan Stitt on 11/10/10
//  Copyright 2011.
//  Distributed under the terms of the GNU General Public License version 3.

// A Note is comprised of an image and an alarm.
// Each note has it's own directory
// It consists of a PNG image and a dictionary encoded into a plist 

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class Note;

@interface NoteTextBlob : NSObject <NSCoding>{
	NSString *text;
	CGRect frame;
	Note *note;
}
-(void)remove;
@property (nonatomic,assign) Note* note;
@property (retain,nonatomic) NSString *text;
@property (nonatomic) CGRect frame;
@end

@interface Note : NSObject {
	NSMutableDictionary *plist;
	UIImage *image;
	UIImage *thumbnail;
	NSMutableArray *texts;
	NSString *directory;
	UILocalNotification *notification;
	NSUInteger index;
}

// we keep an internal cache so we don't have to reload
// the PNGS all the time
+(void)primeCache;

// return a note either from the cache or by creating a new one
// is not intended to be called directly, instead by NotesManager
+(Note*)noteWithDirectory:(NSString*)dir;

// save our plist to 'disk'
-(void)save;

// scedules the alarm
-(void)scedule;

// a thumbnail representation 
// of the image
@property (nonatomic,retain) UIImage* thumbnail;

// the actual drawing
@property (retain,   nonatomic)   UIImage *image;

// does this note have a UILocalNotification set yet?
-(BOOL)hasNotification;

// set coordinate and entering/leaving geo based alarm
-(void)setCoordinate:(CLLocationCoordinate2D)coordinate onEnterRegion:(BOOL)enter;

-(BOOL)onEnterRegion;
-(CLLocationCoordinate2D)coordinate;

// remove the note from storage and cache
-(void)removeSelf;

// the absolute path to the note's directory
-(NSString*)fullDirectoryPath;

-(NoteTextBlob*)addTextBlob;
-(void)removeTextBlob:(NoteTextBlob*)blob;

@property (readonly,nonatomic) NSArray *textBlobs;

// the order that the note should appear in.  
// Is set by NotesManager
@property (readonly, nonatomic ) NSUInteger index;

// how was this alarm set
@property (nonatomic) NSInteger alarmTag;

// the title is what appears above the drawing & selector controllers
@property ( readonly, nonatomic ) NSString* alarmTitle;

// the type could be 'Half Hour', '3 Minutes', etc
@property (assign,  nonatomic )   NSString *alarmType;

@property (nonatomic, readonly ) NSString *alarmText;

@property (assign,   nonatomic )  NSDate *fireDate;

@property (retain,   nonatomic)   UILocalNotification *notification;
@property (readonly, nonatomic)   NSString *directory;


@end
