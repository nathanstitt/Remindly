//
//  NotesScrollView.h
//  Created by Nathan Stitt
//  Copyright 2011.
//  Distributed under the terms of the GNU General Public License version 3.

// NotesScrollView handles hit detection and feeding the UIScrollView
// data in the form of NotePreviewViews

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
 

@class Note, NoteSelectorController;

 
@interface NotesScrollView : UIView<UIScrollViewDelegate> {
	UIScrollView *scrollView;
	NSUInteger currentPage;
	BOOL firstLayout;
	NoteSelectorController *controller;
	NSMutableDictionary *previews;	
}

@property (nonatomic) NSUInteger currentPage;

- (id)initWithController:(NoteSelectorController*)cntr frame:(CGRect)frame;

// called by a preview when it's tapped,
// the notification is then passed on to the selection controller
- (void)noteWasSelected:(Note*)note;

// move to the specified index
- (void)selectNoteIndex:(NSInteger)index;

// redraw the note
- (void)redrawNote:(Note*)note;

// clears all notes, moves to the first index
// and then loads the first and second note previews
- (void)reload;

// clears all notes
- (void)clear;

@end