//
//  NoteSelectorController.m
//
//  Created by Björn Sållarp on 7/14/10.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import "NoteSelectorController.h"
#import "MainViewController.h"
#import "NotesManager.h"
#import "NoteThumbnailView.h"

@implementation NoteSelectorController

-(id) initWithMainView:(MainViewController*)mv {
	self = [ super init ];
	if ( ! self ){
		return nil;
	}
	mainView = mv;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countChanged:) name:NOTES_COUNT_CHANGED_NOTICE object:nil];

	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [ UIColor grayColor ];

    scroller = [ [NotesScrollView alloc] 
                initWithController:self
                frame:CGRectMake(0, 70, 320, 320) ];
	[ scroller setBackgroundColor: [ UIColor grayColor ] ];

	noteHeader = [[ UILabel alloc ] initWithFrame:CGRectMake( 0, 20, 320, 60 ) ];
	noteHeader.lineBreakMode = UILineBreakModeWordWrap;
	noteHeader.numberOfLines = 0;
	noteHeader.textColor = [ UIColor whiteColor ];
	noteHeader.font = [ UIFont systemFontOfSize:18.0];
	noteHeader.backgroundColor = [ UIColor clearColor ];
	noteHeader.textAlignment = UITextAlignmentCenter;
	[ self.view addSubview:noteHeader ];

    [self.view addSubview:scroller];

	NoteThumbnailView *tn = [ scroller loadPage: 0 ];
	tn.focused = YES;
    
	dots = [[ UIPageControl alloc ] init ];
	dots.backgroundColor = [ UIColor grayColor ];
    dots.frame = CGRectMake( 0, 390, 320, 30 );
	dots.numberOfPages = [ NotesManager count ];
	[dots addTarget:self action:@selector(dotsMoved:) forControlEvents:UIControlEventValueChanged];
    
	[ self.view addSubview:dots ];
}


-(void)reload:(Note*)note{
	[ scroller redrawNote: note ];
	if ( note.index == scroller.currentPage ){
		noteHeader.text = [ note alarmTitle ];
	}
}


-(void) selectNoteIndex:(NSInteger)index{
	[ scroller selectNoteIndex: index ];
	dots.currentPage = index;
}

-(NSUInteger)currentIndex {
	return dots.currentPage;
}

-(void)dotsMoved:(id)ctrl{
	[ scroller selectNoteIndex:	dots.currentPage ];
	
}

-(void)countChanged:(NSNotification*)notif	{
	dots.numberOfPages = [ NotesManager count ];
	dots.currentPage = scroller.currentPage-1;
	Note *note = [ NotesManager noteAtIndex: dots.currentPage ];
	noteHeader.text = [ note alarmTitle ];
}

-(void)refresh {
	dots.numberOfPages = [ NotesManager count ];
	dots.currentPage = 0;
	[ scroller reload ];
}


-(void)deleteNote:(Note*)note newIndex:(NSUInteger)index{
	dots.numberOfPages = dots.numberOfPages-1;
	dots.currentPage = index;
	[ scroller clear ];
	[ scroller selectNoteIndex:index ];
}


-(void) addNote:(Note*) note {
    [ self refresh ];
}



-(void) noteWasSelected:(Note*)note{
	[ mainView selectNote:note ];
}


-(void)pageChanged:(NSInteger)noteIndex{
	Note *note = [ NotesManager noteAtIndex:noteIndex];
	noteHeader.text = [ note alarmTitle ];
	dots.currentPage = noteIndex;
}



#pragma mark -
#pragma mark PreviewScrollViewDelegate methods



-(void)startScrolling{
	noteHeader.hidden = YES;
}

-(void)endScrolling{
	noteHeader.hidden = NO;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [ super didReceiveMemoryWarning ];

	// if we aren't shown, clear the scroller
	if ( ! self.view.superview ){
		[ scroller clear ];
        
	}
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self ];
	[ scroller release];
	[ super dealloc];
}

@end
