//
//  NotesManager.m
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

#import "NotesManager.h"
#import "Note.h"
#include <stdlib.h>

static NotesManager *_instance;

@interface NotesManager()
@property (nonatomic,retain) NSMutableDictionary *alerts;
@property (nonatomic,retain) NSMutableArray *dirs;
-(void)sortDirs;
@end

// this is pure evil.  Really wish objective-c allowed 'friend' class declarations like C++
@interface Note(set)
@property (nonatomic) NSUInteger index;
@end

@implementation Note(set)
-(void)setIndex:(NSUInteger)i{
	index = i;
}
-(NSUInteger)index{
	return index;
}

@end

@implementation NotesManager

@synthesize path, dirs, alerts;

+(void)startup {
   if ( ! _instance ){
	   [ Note 	primeCache ];
	   _instance = [[ NotesManager alloc ] init ];
	}
	if ( ! [ NotesManager count ] ){
		[ _instance addNote ];
	}
}


+(NotesManager*)instance{
	return _instance;
} 

+(NSInteger)count {
	return [ _instance.dirs count ];
}

+(NSArray*)notesWithLocationAlarms {
	NSMutableArray *notes = [[ NSMutableArray alloc ] init ];
	for ( NSUInteger i = 0; i < _instance.dirs.count; i++ ){
		Note *note = [ NotesManager noteAtIndex:i ];
		if ( [note hasCoordinate] ){
			[ notes addObject: note ];
		}
	}
	return [notes autorelease];
}

+(Note*)noteAtIndex:(NSUInteger)index {
	Note *note = [ Note noteWithDirectory:[ _instance.dirs objectAtIndex:index] ];
	note.index = index;
	if ( ! [note hasNotification] ){
		UILocalNotification *notif = [ _instance.alerts valueForKey: note.directory ];
		if ( notif ){
			note.notification = notif;
		}
	}
	return note;
}

-(id)init{
    self = [super init ];
	
	alerts = [[ NSMutableDictionary alloc ] init ];
	dirs   = [[ NSMutableArray      alloc ] init ];
	
	NSError *error;

	NSFileManager *fm = [ NSFileManager defaultManager ];

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

	path = [ [paths objectAtIndex:0] stringByAppendingPathComponent: @"notes" ];
	[ path retain ];

	if ( ! [ fm fileExistsAtPath:path ] ){
		[ fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error ];
	}

	NSDirectoryEnumerator *dirEnum = [ fm enumeratorAtPath:path ];
	NSString *note_file;
	while ( (note_file = [dirEnum nextObject]) ) {
		[ dirEnum skipDescendents ];
		NSString *dir = [ path stringByAppendingPathComponent:note_file ];
		if ( [ [ [ fm attributesOfItemAtPath:dir error:NULL ] valueForKey:@"NSFileType"] isEqualToString:@"NSFileTypeDirectory" ] ){
			[ dirs addObject: note_file ];
		}
	}

	for ( UILocalNotification *notification in [UIApplication sharedApplication].scheduledLocalNotifications ){
		NSString *dir = [ notification.userInfo objectForKey:@"directory"]; 
		if ( dir ){
			 [ alerts setObject: notification forKey: dir ];
		}
	}
	[ self sortDirs ];
	return self;
}



NSComparisonResult
compare(NSString *dir1, NSString *dir2, void *context) {
	NSFileManager *fm = [ NSFileManager defaultManager ];

	return  [ [ [   fm attributesOfItemAtPath:dir1 error:NULL ] valueForKey:@"NSFileCreationDate"]  compare:
				[ [ fm attributesOfItemAtPath:dir2 error:NULL ] valueForKey:@"NSFileCreationDate"] 
			 ];
}

-(void)sortDirs {
	[ dirs setArray: [ dirs sortedArrayUsingSelector: @selector(compare:) ] ];
}

-(BOOL)hasNoteWithDirectory:(NSString*)dir {
	return ( NSNotFound != [ dirs indexOfObject: dir ] );
}

-(Note*)noteWithDirectory:(NSString*)dir {
	NSUInteger indx = [ dirs indexOfObject: dir ];
	if (  NSNotFound != indx ){
		Note *note = [ Note noteWithDirectory:dir ];
		note.index = indx;
		UILocalNotification *notification = [ alerts objectForKey: dir ];
		if ( notification ){
			note.notification = notification;
		}
		return note;
	} else {
		return nil;
	}
}


-(Note*)deleteNote:(Note*)note{
	[ dirs removeObject: note.directory ];
	[ alerts removeObjectForKey: note.directory ];
	Note *ret;
	if ( ! [ dirs count ] ){
		ret = [ self addNote ];
	} else if ( note.index < [ NotesManager count ] ){
		ret = [ NotesManager noteAtIndex: note.index ];
	} else {
		ret = [ NotesManager noteAtIndex: 0 ];	
	}
	[ note removeSelf ];
	[[ NSNotificationCenter defaultCenter ] postNotificationName:NOTES_COUNT_CHANGED_NOTICE object: self ];
	return ret;
}


-(NSString*)createNoteDirectory {
	NSFileManager *fm = [ NSFileManager defaultManager ];

	NSString *nm = [ NSString stringWithFormat:@"%d",(arc4random() % 10000) ];
	while ( [ fm fileExistsAtPath: [ self.path stringByAppendingPathComponent: nm ] ] ){
		nm = [ NSString stringWithFormat:@"%d",(arc4random() % 10000) ];
	}
	NSString *fullPath = [ self.path stringByAppendingPathComponent: nm ];
	
	[ fm createDirectoryAtPath:  fullPath withIntermediateDirectories:YES attributes:nil error:NULL];
	
	[ UIImagePNGRepresentation( [ UIImage imageNamed:@"blank.png" ] )
		writeToFile:[ fullPath stringByAppendingPathComponent:@"image.png"] atomically:YES];

	[ UIImagePNGRepresentation( [ UIImage imageNamed:@"blank.png" ] )
		writeToFile:[ fullPath stringByAppendingPathComponent:@"thumbnail.png"] atomically:YES];


	[ fm copyItemAtPath:[[[NSBundle mainBundle] resourcePath] 
						 stringByAppendingPathComponent:@"empty.plist"]
						 toPath:[ fullPath stringByAppendingPathComponent:@"info.plist"]
						 error:NULL];

	return nm;
}


-(Note*)addNote {
	Note *note = [ Note noteWithDirectory: [ self createNoteDirectory ] ];
	[ note save ];
	[ dirs insertObject: note.directory atIndex:0 ];
	[[ NSNotificationCenter defaultCenter ] postNotificationName:NOTES_COUNT_CHANGED_NOTICE object: self ];
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
	return ( [ dirs count ] < self.maxNumberOfNotes );
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
