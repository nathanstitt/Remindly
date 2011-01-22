#import "NotesScrollView.h"
#import "NotesManager.h"

#define SHADOW_HEIGHT 20.0
#define SHADOW_INVERSE_HEIGHT 10.0
#define SHADOW_RATIO (SHADOW_INVERSE_HEIGHT / SHADOW_HEIGHT)
 
@implementation	NotesScrollView

@synthesize scrollView, pageSize, dropShadow, delegate;

 
- (id)initWithFrameAndPageSize:(CGRect)frame pageSize:(CGSize)size {    
	if (self = [self initWithFrame:frame]) {
		self.pageSize = size;
    }
	firstLayout = YES;
	dropShadow = YES;
	lastPage = 0;
    return self;
}
 
-(void)loadPage:(int)page {
	// Sanity checks
    if ( page < 0 || page > [ NotesManager count ]-1 ){
		return;
	}

	// Check if the page is already loaded
	UIView *view = [ delegate viewForItemAtIndex:self index:page ];

	// add the controller's view to the scroll view	if it's not already added
	if (view.superview == nil) {
		// Position the view in our scrollview
		CGRect viewFrame = view.frame;
		viewFrame.origin.x = viewFrame.size.width * page;
		viewFrame.origin.y = 0;
 
		view.frame = viewFrame;
 
		[self.scrollView addSubview:view];
	}
}
 

- (void)layoutSubviews {
	// We need to do some setup once the view is visible. This will only be done once.
	if(firstLayout)	{
 
		// Position and size the scrollview. It will be centered in the view.
		CGRect scrollViewRect = CGRectMake(0, 0, pageSize.width, pageSize.height);
		scrollViewRect.origin.x = ((self.frame.size.width - pageSize.width) / 2);
		scrollViewRect.origin.y = ((self.frame.size.height - pageSize.height) / 2);
 
		scrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect];
		scrollView.clipsToBounds = NO; // Important, this creates the "preview"
		scrollView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20 );
		scrollView.contentOffset = CGPointMake(20, 0);
		scrollView.pagingEnabled = YES;
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.delegate = self;
 
		[ self addSubview:scrollView ];

                        
		[ self reload ];
		// Load the first two pages

		firstLayout = NO;
	}
}


- (void)reload {
	self.scrollView.contentSize = CGSizeMake([NotesManager count] * self.scrollView.frame.size.width, 
											 scrollView.frame.size.height);

	for (UIView *view in [self.scrollView subviews]) {
		[view removeFromSuperview];
	}
	[ self loadPage:0 ];
	[ self loadPage:1 ];
	
	[ self selectNoteIndex: 0 ];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
 
	// If the point is not inside the scrollview, ie, in the preview areas we need to return
	// the scrollview here for interaction to work
	if (!CGRectContainsPoint(scrollView.frame, point)) {
		return self.scrollView;
	}
 
	// If the point is inside the scrollview there's no reason to mess with the event.
	// This allows interaction to be handled by the active subview just like any scrollview
	return [super hitTest:point	withEvent:event];
}
 
-(int)currentPage {
	// Calculate which page is visible 
	CGFloat pageWidth = scrollView.frame.size.width;
	int page = floor( ( scrollView.contentOffset.x - pageWidth / 2 ) / pageWidth ) + 1;
	if ( page >=0 && page < [ NotesManager count] && page != lastPage ){
		lastPage = page;
		[ delegate pageChanged: page ];
	}
	return page;
}
 
- (void)selectNoteIndex:(NSInteger)index{
	[ scrollView setContentOffset:CGPointMake(scrollView.frame.size.width*index,0 ) ];
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods
 
-(void)scrollViewDidScroll:(UIScrollView *)sv {
	int page = [self currentPage];
 
	// Load the visible and neighbouring pages 
	[self loadPage:page-1];
	[self loadPage:page];
	[self loadPage:page+1];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	[ delegate startScrolling ];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[ delegate endScrolling ];	
}
#pragma mark -
#pragma mark Memory management
 
 
- (void)dealloc {
	[ scrollView release ];
	[ super dealloc      ];
}
 
 
@end
