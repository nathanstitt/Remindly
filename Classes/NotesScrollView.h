#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
 
 
@class NotesScrollView;
 
@protocol NotesScrollViewDelegate
@required
-(UIView*)viewForItemAtIndex:(NotesScrollView*)scrollView index:(int)index;
-(int)itemCount;
-(void)pageChanged:(NSInteger)note;
-(void)startScrolling;
-(void)endScrolling;
@end
 
 
@interface NotesScrollView : UIView<UIScrollViewDelegate> {
	UIScrollView *scrollView;
	id<NotesScrollViewDelegate> delegate;
	NSInteger lastPage;
	BOOL firstLayout;
	CGSize pageSize;
	BOOL dropShadow;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) id<NotesScrollViewDelegate> delegate;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) BOOL dropShadow;


- (id)initWithFrameAndPageSize:(CGRect)frame pageSize:(CGSize)size;
- (void)selectPage:(NSInteger)index;
- (void)reload;

@end