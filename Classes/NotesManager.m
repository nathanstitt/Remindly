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
@end

@implementation NotesManager

@synthesize notes,path;

+(void)start{
	[ _instance release ];
	_instance = [[ NotesManager alloc ] init ];
}


+(NotesManager*)instance{
	return _instance;
}

-(id)init{
    self = [super init ];
	
	notes = [[ NSMutableArray alloc ] init ];
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
			Note *note = [[ Note alloc ] initWithDirectoryName:dir ];
			[ notes addObject:note ];
			[ note release ];
		}
	}
	for ( UILocalNotification *notification in [UIApplication sharedApplication].scheduledLocalNotifications ){
		Note* note = [self noteWithDirectory: [ notification.userInfo objectForKey:@"directory"] ];
		if ( note ){
				note.notification = notification;
		}
	}
	NSSortDescriptor *dateSorter = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:NO ];
	[ notes sortUsingDescriptors:[NSArray arrayWithObject:dateSorter]];
	[ dateSorter release ];
    return self;
}


-(Note*)noteWithDirectory:(NSString*)dir {
	for ( Note *note in notes ){
		if ( [note.directory isEqual: dir ] ){
			return note;
		}
	}
	return NULL;
}


-(Note*)deleteNote:(Note*)note{
	NSInteger i = [ notes indexOfObject: note ];
	if ( NSNotFound == i ){
		return note;
	}
	[ note deleteFromDisk ];
	[ notes removeObjectAtIndex: i ];
	if ( ! [ notes count ] ){
		return [ self addNote ];
	} else {
		if ( i == [ notes count ] ){
			i = [ notes count ]-1;
		}
		return [ notes objectAtIndex: i ];
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
	Note *note = [[ Note alloc ] initWithDirectoryName: [ self createNoteDirectory ] ];
	[ note save ];
	[ notes insertObject:note atIndex:0];
	return [ note autorelease ];
}

-(NSInteger)maxNumberOfNotes{
	return [[NSUserDefaults standardUserDefaults] integerForKey:@"numberNotesAllowed"];
}

-(void)setMaxNumberOfNotes:(NSInteger)n{
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	[ defs setInteger:n forKey:@"numberNotesAllowed"];
	[ defs synchronize ];
}


-(BOOL)isAllowedMoreNotes {
	return YES;
	return ( [ notes count ] < self.maxNumberOfNotes );
}

-(Note*)defaultEditingNote{
	return [ notes count ] ? [ notes objectAtIndex: 0 ] : [ self addNote ];
}

- (void)dealloc {
	[ path  release ];
	[ notes release ];
    [ super dealloc ];
}

@end
