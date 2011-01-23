/*  This file is part of Remindly.

    Remindly is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3.

    Remindly is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Remindly.  If not, see <http://www.gnu.org/licenses/>.
*/


#import "NotesScrollView.h"
#import "NotesManager.h"
#import "NotePreviewView.h"
#import "NoteSelectorController.h"


@implementation	NotesScrollView

#define PAGE_WIDTH 213 
#define PAGE_HEIGHT 280

@synthesize currentPage;
 
- (id)initWithController:(NoteSelectorController*)cntr 
					frame:(CGRect)frame {
	
	if ( self != [self initWithFrame:frame]) {
		return nil;
    }
	controller = cntr;
	previews = [[ NSMutableDictionary alloc ] init ];
	firstLayout = YES;
	currentPage = 0;

	// Position and size the scrollview. It will be centered in the view.
	CGRect scrollViewRect = CGRectMake(0, 0, PAGE_WIDTH, PAGE_HEIGHT );
	scrollViewRect.origin.x = ((self.frame.size.width - PAGE_WIDTH ) / 2);
	scrollViewRect.origin.y = ((self.frame.size.height - PAGE_HEIGHT ) / 2);
 
	scrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect];
	scrollView.clipsToBounds = NO;
	scrollView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20 );
	scrollView.contentOffset = CGPointMake(20, 0);
	scrollView.pagingEnabled = YES;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.delegate = self;
 
	[ self addSubview:scrollView ];

             	
    return self;
}

-(NotePreviewView*)viewAtIndex:(NSUInteger)index {

	NotePreviewView *v = [ previews objectForKey:[ NSNumber numberWithInt:index ] ];
	if ( ! v ){
		v = [ [ NotePreviewView alloc ] initWithNote: [ NotesManager noteAtIndex: index ] 
				frame:CGRectMake(0, 0, PAGE_WIDTH, PAGE_HEIGHT )
				scroller:self ];
		[ previews setObject: v forKey: [ NSNumber numberWithInt:index ] ];
	}
	return v;
}

-(void)loadPage:(NSUInteger)page {
	// Sanity checks
    if ( page > [ NotesManager count ]-1 ){
		return;
	}

	// Check if the page is already loaded
	NotePreviewView *view = [ self viewAtIndex:page ];

	// add the controller's view to the scroll view	if it's not already added
	if (view.superview == nil) {
		// Position the view in our scrollview
		CGRect viewFrame = view.frame;
		viewFrame.origin.x = viewFrame.size.width * page;
		viewFrame.origin.y = 0;
 
		view.frame = viewFrame;
 
		[ scrollView addSubview:view];
	}

}


- (void)layoutSubviews {
	// We need to do some setup once the view is visible. This will only be done once.
	if(firstLayout)	{
		[ self reload ];
		firstLayout = NO;
	}
}

-(void)clear {
	for (UIView *view in [ scrollView subviews]) {
		[view removeFromSuperview];
	}
	[ previews removeAllObjects ];
	
}

-(void)redrawNote:(Note*)note{
	NotePreviewView *v = [ previews objectForKey:[ NSNumber numberWithInt: note.index ] ];
	if ( v ){
		v.note = note;
	}
}

- (void)reload {
	scrollView.contentSize = CGSizeMake([NotesManager count] * scrollView.frame.size.width, 
											 scrollView.frame.size.height);

	[ self clear ];
	[ self loadPage:0 ];
	[ self loadPage:1 ];
	
	[ self selectNoteIndex: 0 ];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
 
	// If the point is not inside the scrollview, ie, in the preview areas we need to return
	// the scrollview here for interaction to work
	if (!CGRectContainsPoint(scrollView.frame, point)) {
		return scrollView;
	}
 
	// If the point is inside the scrollview there's no reason to mess with the event.
	// This allows interaction to be handled by the active subview just like any scrollview
	return [super hitTest:point	withEvent:event];
}
 


-(NSUInteger)calcPage {
	
	CGFloat pageWidth = scrollView.frame.size.width;
    return MIN( [ NotesManager count ]-1,
			   MAX( 0, floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1 ) );
}

- (void)selectNoteIndex:(NSInteger)index{
	[ scrollView setContentOffset:CGPointMake(scrollView.frame.size.width*index,0 ) ];
}

-(void) noteWasSelected:(Note*)note{
	[ controller noteWasSelected:note ];
}


#pragma mark -
#pragma mark UIScrollViewDelegate methods
 
-(void)scrollViewDidScroll:(UIScrollView *)sv {
	int page = [self calcPage];
	if ( page == currentPage )
		return;

	[ controller pageChanged: page ];

	// Load the visible and neighbouring pages 
	if ( page > 1 ){
		[self loadPage:page-1];
	}
	[self loadPage:page];
	if ( page < [ NotesManager count ] ){
		[self loadPage:page+1];
	}

	currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	[ controller startScrolling ];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[ controller endScrolling ];	
}
#pragma mark -
#pragma mark Memory management
 
 
- (void)dealloc {
	[ previews   release ];
	[ scrollView release ];
	[ super      dealloc ];
}
 
 
@end
