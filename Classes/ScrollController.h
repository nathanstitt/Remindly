//
//  ScrollViewPreviewViewController.h
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
#import "NotePreviewView.h"
#import "Note.h"

@class MainViewController;

@interface ScrollController : UIViewController<NotesScrollViewDelegate> {
	NotesScrollView *scroller;
	UILabel *noteHeader;
	UIPageControl *dots;
	MainViewController *mainView;
	NSMutableDictionary *previews;
}

-(void) reload:(Note*)note;
-(void) selectNoteIndex:(NSInteger)index;

//-(void) addNotes:(NSArray*)notes;
//-(void) deleteNote:(Note*)note;
//-(void) addNote:(Note*)note;

-(void) pageChanged:(NSInteger)index;
-(void) noteWasSelected:(Note*)note;
-(id)   initWithMainView:(MainViewController*)mv;

@property (nonatomic) BOOL hidden;

@end

