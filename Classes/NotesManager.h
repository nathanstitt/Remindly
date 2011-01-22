//
//  NotesManager.h
//  IoGee
//
//  Created by Nathan Stitt on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

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
+(Note*)noteAtIndex:(NSInteger)index;
+(NSInteger)indexOfNote:(Note*)note;

-(Note*)defaultEditingNote;
-(Note*)addNote;
-(BOOL)isAllowedMoreNotes;
-(BOOL)hasBeenUpgraded;
-(void)upgradeAllowedNoteCount:(BOOL)unlimited;


-(Note*)deleteNote:(Note*)note;

-(Note*)noteWithDirectory:(NSString*)dir;

// @property ( nonatomic, readonly ) BOOL isUnlimited;
// @property (readonly,nonatomic) NSArray *notes;

@end
