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

@implementation ScrollController
@synthesize scrollPages, scrollViewPreview;

-(id) initWithMainView:(MainViewController*)mv {
	self = [ super init ];
	mainView = mv;
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [ UIColor grayColor ];

	// You can add the control programatically like so:
	// Position the scrollview. It will be centered in the portrait view. The viewSize defines the size 
	// of each item you want to display in your scroll view. The size of the "preview" on each side equals the
	// width of the frame minus the width of the "view", ie, 320 - 240 = 60 / 2 = 30. 
	scrollViewPreview = [ [PreviewScrollView alloc]	initWithFrameAndPageSize: CGRectMake(0, 70, 320, 320) 
													pageSize: CGSizeMake( 213, 280 ) ];

	[ scrollViewPreview setBackgroundColor: [ UIColor grayColor ] ];
	
	scrollViewPreview.delegate = self;
	[self.view addSubview:scrollViewPreview];
	[ scrollViewPreview selectPage:0 ];
	
	pageControl = [[ UIPageControl alloc ] init ];
	pageControl.backgroundColor = [ UIColor grayColor ];
	pageControl.frame = CGRectMake( 0, 390, 320, 30 );
	[pageControl addTarget:self action:@selector(pageControlMoved:) forControlEvents:UIControlEventValueChanged];
	
	[ self.view addSubview:pageControl ];
	
	notes = [[ NSMutableArray alloc ] init ];
}

-(void)reload:(Note*)note{
	for ( TapImage *image in notes ){
		if ( note == image.note ){
			[ image reload ];
		}
	}
}

-(void)pageControlMoved:(id)ctrl{
	[ scrollViewPreview selectPage:	pageControl.currentPage ];
}

-(void) addNotes:(NSArray*)nts{
	for( Note *note in nts ){
		[ notes addObject: [[TapImage alloc ] 
						   initWithNote: note 
						   frame:CGRectMake(0, 0, scrollViewPreview.pageSize.width, scrollViewPreview.pageSize.height)
						   scroller:self ] 
				 ];
	}
	pageControl.numberOfPages = [ notes count ];
	[ scrollViewPreview reload ];
}

-(void)refresh {
	pageControl.numberOfPages = [ notes count ];
	pageControl.currentPage = 0;
	[scrollViewPreview selectPage: 0];
	[ scrollViewPreview reload ];
}

-(void)deleteNote:(Note*)note{
	NSInteger i = 0;
	TapImage *ti;
	for ( ti in notes ){
		if ( ti.note == note ){
			[ notes removeObjectAtIndex:i ];
			break;
		}
		i++;
	}
	[ self refresh ];
}

-(void) addNote:(Note*) note {
	[ notes insertObject: [[TapImage alloc ] 
						initWithNote: note 
						frame:CGRectMake(0, 0, scrollViewPreview.pageSize.width, scrollViewPreview.pageSize.height)
						scroller:self ] 
			  atIndex: 0 ];

	[ self refresh ];
}

-(void) selectNote:(Note*)note{
	NSInteger index = 0;
	for (TapImage *img in notes ){
		if ( note ==  img.note ){
			[scrollViewPreview selectPage:index ];
			return;
		}
		index++;
	}
}

-(void) noteWasSelected:(Note*)note{
	[ mainView noteWasSelected:note ];
}

-(void)pageChanged:(NSInteger)noteIndex{
	pageControl.currentPage = noteIndex;
//-(void)noteScrolled:(Note*)current {
    // Switch the indicator when more than 50% of the previous/next page is visible
//    CGFloat pageWidth = scrollView.frame.size.width;
//  int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    pageControl.currentPage = page;
	
}

#pragma mark -
#pragma mark PreviewScrollViewDelegate methods
-(UIView*)viewForItemAtIndex:(PreviewScrollView*)scrollView index:(int)index {
	
	return [ notes objectAtIndex:index ];
}

-(int)itemCount:(PreviewScrollView*)scrollView {
	// Return the number of pages we intend to display
	return [ notes count ];
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
	[ scrollViewPreview release];
	[ scrollPages release];
	[ notes release ];
    [ super dealloc];
}

@end
