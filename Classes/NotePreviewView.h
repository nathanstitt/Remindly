//
//  NotePreviewView.h
//  Created by Nathan Stitt
//  Copyright 2011.
//  Distributed under the terms of the GNU General Public License version 3.

// NotesScrollView handles hit detection and feeding the UIScrollView
// data in the form of NotePreviewViews

#import <Foundation/Foundation.h>
#import "Note.h"

@class NotesScrollView;

@interface NotePreviewView : UIView {
	Note *note;
	UIImageView *imageView;
	NotesScrollView *scroller;
}

-(id)initWithNote:(Note*)n frame:(CGRect)frame scroller:(NotesScrollView*)sc;


@property (nonatomic,retain) Note *note;

@end
