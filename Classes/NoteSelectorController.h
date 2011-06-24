//
//  NoteSelectorController.h
//
//  I've taken the initial concept for this from  Björn Sållarp
//  and tweaked it a good bit to take it's data directly from
//  the NotesManager instead of the delegate.
//
//  Since he provided the initial concept, I'm leaving his notices
//  intact below
//
//  Created by Björn Sållarp on 7/14/10.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import <UIKit/UIKit.h>
#import "NotesScrollView.h"
#import "NoteThumbnailView.h"
#import "Note.h"

@class MainViewController;

@interface NoteSelectorController : UIViewController {
	NotesScrollView *scroller;
	UILabel *noteHeader;
	UIPageControl *dots;
	MainViewController *mainView;
}

// init and remember the pointer to the MainView as we
// use that for callbacks
-(id)   initWithMainView:(MainViewController*)mv;


// where we are
-(NSUInteger) currentIndex;


// the scroller is started moving we hide the header
-(void) startScrolling;


// clears all thumbnails previews
// called before view will become active
-(void)reload;

// move scroller & other data (header, dots, etc) to correspond to index
-(void) selectNoteIndex:(NSInteger)index;

// add a note, will also go to first index
// as that's where the note will be
-(void) addNote:(Note*)note;

// the scroller has stopped moving - show the header
-(void) endScrolling;

// remove a note from the scroller, and switch to index
-(void) deleteNote:(Note*)note newIndex:(NSUInteger)index;

// notification that the page has changed
-(void) pageChanged:(NSInteger)index;

// a note was selected
-(void) noteWasSelected:(Note*)note;

@end

