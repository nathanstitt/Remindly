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
	NSMutableArray *notes;
	NSString *path;
}

+(void)start;
+(NotesManager*)instance;
-(Note*)defaultEditingNote;
-(Note*)addNote;
-(Note*)noteWithDirectory:(NSString*)dir;
-(Note*)deleteNote:(Note*)note;
-(BOOL)isAllowedMoreNotes;


@property ( nonatomic ) NSInteger maxNumberOfNotes;
@property (readonly,nonatomic) NSArray *notes;
@end
