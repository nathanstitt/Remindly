//
//  NotesManager.m
//  IoGee
//
//  Created by Nathan Stitt on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NotesManager.h"
#import "Note.h"
#include <stdlib.h>

static NotesManager *_instance;

@interface NotesManager()
@property (nonatomic,retain) NSString *path;
@property (nonatomic,retain) NSMutableDictionary *alerts;
@property (nonatomic,retain) NSMutableArray *dirs;

@end

@implementation NotesManager

@synthesize path, dirs, alerts;

+(void)start{
	[ _instance release ];
	_instance = [[ NotesManager alloc ] init ];
}


+(NotesManager*)instance{
	return _instance;
}

+(NSInteger)indexOfNote:(Note*)note{
	return [ _instance.dirs indexOfObject: note.directory ];
}

+(NSInteger)count {
	return [ _instance.dirs count ];
}

+(Note*)noteAtIndex:(NSInteger)index {
	return [ Note noteWithDirectory:[ [ _instance.dirs sortedArrayUsingSelector: @selector(compare:) ]  objectAtIndex:index] ];
}

-(id)init{
    self = [super init ];
	
	alerts = [[ NSMutableDictionary alloc ] init ];
	dirs   = [[ NSMutableArray      alloc ] init ];
	
	NSError *error;

	NSFileManager *fm = [ NSFileManager defaultManager ];

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

	self.path = [ [paths objectAtIndex:0] stringByAppendingPathComponent: @"notes" ];

	if ( ! [ fm fileExistsAtPath:path ] ){
		[ fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error ];
	}

	NSDirectoryEnumerator *dirEnum = [ fm enumeratorAtPath:path ];
	NSString *note_file;
	while ( note_file = [dirEnum nextObject] ) {
		[ dirEnum skipDescendents ];
		NSString *dir = [ path stringByAppendingPathComponent:note_file ];
		if ( [ [ [ fm attributesOfItemAtPath:dir error:NULL ] valueForKey:@"NSFileType"] isEqualToString:@"NSFileTypeDirectory" ] ){
			[ dirs addObject: dir ];
		}
	}

	for ( UILocalNotification *notification in [UIApplication sharedApplication].scheduledLocalNotifications ){
		if ( [ alerts objectForKey: [ notification.userInfo objectForKey:@"directory"] ] ){
			 [ alerts setObject: notification forKey:[ notification.userInfo objectForKey:@"directory"] ];
		}
	}
	return self;
}

NSComparisonResult
compare(NSString *dir1, NSString *dir2, void *context) {
	NSFileManager *fm = [ NSFileManager defaultManager ];

	return  [ [ [   fm attributesOfItemAtPath:dir1 error:NULL ] valueForKey:@"NSFileCreationDate"]  compare:
				[ [ fm attributesOfItemAtPath:dir2 error:NULL ] valueForKey:@"NSFileCreationDate"] 
			 ];
}


-(Note*)noteWithDirectory:(NSString*)dir {
	id notification;
	if ( (  notification = [ alerts objectForKey: dir ] ) ){
		Note *n = [ Note noteWithDirectory:dir ];
		if ( [ notification isKindOfClass:[UILocalNotification class]] ){
			n.notification = notification;
		}
	} else {
		return nil;
	}
	return NULL;
}

-(Note*)deleteNote:(Note*)note{
	[ note deleteFromDisk ];
	[ dirs removeObject: note.directory ];
	[ alerts removeObjectForKey: note.directory ];
	if ( ! [ dirs count ] ){
		return [ self addNote ];
	} else {
		return [ NotesManager noteAtIndex:0 ];
	}
}


-(NSString*)createNoteDirectory {
	NSFileManager *fm = [ NSFileManager defaultManager ];

	NSString *nm = [ self.path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",(arc4random() % 10000) ] ];
	while ( [ fm fileExistsAtPath: nm ] ){
		nm = [ self.path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d",(arc4random() % 10000) ] ];
	}

	[ fm createDirectoryAtPath:nm withIntermediateDirectories:YES attributes:nil error:NULL];
	
	[ UIImagePNGRepresentation( [ UIImage imageNamed:@"blank.png" ] )
		writeToFile:[ nm stringByAppendingPathComponent:@"image.png"] atomically:YES];


	[ fm copyItemAtPath:[[[NSBundle mainBundle] resourcePath] 
						 stringByAppendingPathComponent:@"empty.plist"]
						 toPath:[ nm stringByAppendingPathComponent:@"info.plist"]
						 error:NULL];

	return nm;
}


-(Note*)addNote {
	Note *note = [ Note noteWithDirectory: [ self createNoteDirectory ] ];
	[ note save ];
	[ dirs addObject: note.directory ];
	return note;
}

-(NSInteger)maxNumberOfNotes{
	return [[NSUserDefaults standardUserDefaults] integerForKey:@"numberNotesAllowed"];
}

-(void)setMaxNumberOfNotes:(NSInteger)n{
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	[ defs setInteger:n forKey:@"numberNotesAllowed"];
	[ defs synchronize ];
}

-(BOOL)hasBeenUpgraded {
	return ( [ self maxNumberOfNotes ] > 2 );
}

-(void)upgradeAllowedNoteCount:(BOOL)unlimited{
	if ( unlimited ){
		[ self setMaxNumberOfNotes:99999];
	} else if ( [ self maxNumberOfNotes ] < 5 ){
		[ self setMaxNumberOfNotes: 5 ];
	}
}

-(BOOL)isAllowedMoreNotes {
	return YES; // ( [ dirs count ] < self.maxNumberOfNotes );
}

-(Note*)defaultEditingNote {
	return [ [ _instance dirs ] count ] ? [ NotesManager noteAtIndex: 0 ] : [ self addNote ];
}

- (void)dealloc {
	[ path   release ];
	[ dirs   release ];
	[ alerts release ];
    [ super  dealloc ];
}

@end
