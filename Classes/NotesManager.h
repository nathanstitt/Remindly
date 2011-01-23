//
//  Created by Nathan Stitt on 11/10/10
//  Copyright 2011.
//  Distributed under the terms of the GNU General Public License version 3.

// NotesManager, manages, wait for it.... Notes
// On startup, it reads in the directories, sorts
// them by date created, and caches them.
// then when a client requests Note at an index, it c
// requests it from [ Note noteWithDirectory] and returns it
// it also keeps a cache of pending notifications


#import <Foundation/Foundation.h>
#import "Note.h"

@interface NotesManager : NSObject {
	NSMutableArray *dirs;
	NSMutableDictionary *alerts;
	NSString *path;
}

+(void)start;
+(NotesManager*)instance;
+(NSInteger)count;
+(Note*)noteAtIndex:(NSUInteger)index;


-(Note*)addNote;
-(BOOL)isAllowedMoreNotes;
-(BOOL)hasBeenUpgraded;
-(void)upgradeAllowedNoteCount:(BOOL)unlimited;

-(Note*)deleteNote:(Note*)note;
-(Note*)noteWithDirectory:(NSString*)dir;

@property (readonly,nonatomic) NSString*path;

@end
