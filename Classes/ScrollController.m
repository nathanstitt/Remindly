//
//  ScrollViewPreviewViewController.m
//
//  Created by Björn Sållarp on 7/14/10.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import "ScrollController.h"
#import "MainViewController.h"
#import "NotesManager.h"
#import "NotePreviewView.h"

@implementation ScrollController

-(id) initWithMainView:(MainViewController*)mv {
	self = [ super init ];
	mainView = mv;
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [ UIColor grayColor ];

	previews = [[ NSMutableDictionary alloc ] init ];
	
	// You can add the control programatically like so:
	// Position the scrollview. It will be centered in the portrait view. The viewSize defines the size 
	// of each item you want to display in your scroll view. The size of the "preview" on each side equals the
	// width of the frame minus the width of the "view", ie, 320 - 240 = 60 / 2 = 30. 
	scroller = [ [NotesScrollView alloc]	initWithFrameAndPageSize: CGRectMake(0, 70, 320, 320) 
													pageSize: CGSizeMake( 213, 280 ) ];

	[ scroller setBackgroundColor: [ UIColor grayColor ] ];
	noteHeader = [[ UILabel alloc ] initWithFrame:CGRectMake( 0, 20, 320, 60 ) ];
	noteHeader.lineBreakMode = UILineBreakModeWordWrap;
	noteHeader.numberOfLines = 0;
	noteHeader.textColor = [ UIColor whiteColor ];
	noteHeader.font = [ UIFont systemFontOfSize:18.0];
	noteHeader.backgroundColor = [ UIColor clearColor ];
	noteHeader.text = @"Foo Bar Bang Bing";
	noteHeader.textAlignment = UITextAlignmentCenter;
	
	[ self.view addSubview:noteHeader ];
	
	scroller.delegate = self;
	[self.view addSubview:scroller];
	[ scroller selectNoteIndex:0 ];
	
	dots = [[ UIPageControl alloc ] init ];
	dots.backgroundColor = [ UIColor grayColor ];
	dots.frame = CGRectMake( 0, 390, 320, 30 );
	[dots addTarget:self action:@selector(dotsMoved:) forControlEvents:UIControlEventValueChanged];
	
	[ self.view addSubview:dots ];
	
}

-(void)reload:(Note*)note{
	NSInteger i = 0;
//	for ( NotePreviewView *image in images ){
//		if ( note == image.note ){
//			[ image reload ];
//			break;
//		}
//		i++;
//	}
	noteHeader.text = [ note alarmDescription ];
	dots.currentPage = i;
}


-(void) selectNoteIndex:(NSInteger)index{
//-(void) selectNote:(Note*)note{
	[ scroller selectNoteIndex: index ];
	dots.currentPage = 0;
}

-(void)dotsMoved:(id)ctrl{
	[ scroller selectNoteIndex:	dots.currentPage ];
	
}

-(void) addNotes:(NSArray*)nts{
//	for( Note *note in nts ){
//		[ images addObject: [[NotePreviewView alloc ] 
//						   initWithNote: note 
//						   frame:CGRectMake(0, 0, scroller.pageSize.width, scroller.pageSize.height)
//						   scroller:self ] 
//				 ];
//	}
	dots.numberOfPages = [ NotesManager count ];
	[ scroller reload ];
}

-(void)refresh {
	dots.numberOfPages = [ NotesManager count ];
	dots.currentPage = 0;
	[ scroller selectNoteIndex: 0];
	[ scroller reload ];
}


//-(void)deleteNote:(Note*)note{
//	NSInteger i = 0;
//	NotePreviewView *ti;
//	for ( ti in images ){
//		if ( ti.note == note ){
//			[ images removeObjectAtIndex:i ];
//			break;
//		}
//		i++;
//	}
//	[ self refresh ];
//}


//-(void) addNote:(Note*) note {
//	[ images insertObject: [[NotePreviewView alloc ] 
//						initWithNote: note 
//						frame:CGRectMake(0, 0, scroller.pageSize.width, scroller.pageSize.height)
//						scroller:self ] 
//			  atIndex: 0 ];
//
//	[ self refresh ];
//}



-(void) noteWasSelected:(Note*)note{
	[ mainView noteWasSelected:note ];
}


-(void)pageChanged:(NSInteger)noteIndex{
	Note *note = [NotesManager noteAtIndex:noteIndex];
	noteHeader.text = [ note alarmDescription ];
	dots.currentPage = noteIndex;
}


-(BOOL)hidden {
	return self.view.hidden;
}


-(void)setHidden:(BOOL)h {
	self.view.hidden = h;
}


#pragma mark -
#pragma mark PreviewScrollViewDelegate methods

-(UIView*)viewForItemAtIndex:(NotesScrollView*)scrollView index:(int)index {
	
	NotePreviewView *v = [ previews objectForKey:[ NSNumber numberWithInt:index ] ];
	if ( ! v ){
		v = [ [ NotePreviewView alloc ] initWithNote: [ NotesManager noteAtIndex: index ] 
				frame:CGRectMake(0, 0, scroller.pageSize.width, scroller.pageSize.height)
				scroller:self ];
		[ previews setObject: v forKey: [ NSNumber numberWithInt:index ] ];
	}
	return v;
}

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
	
	// Call the scrollview and let it know memory is running low

}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[ scroller release];
	[ super dealloc];
}

@end
