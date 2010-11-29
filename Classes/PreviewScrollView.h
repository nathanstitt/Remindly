#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
 
 
@class PreviewScrollView;
 
@protocol PreviewScrollViewDelegate
@required
-(UIView*)viewForItemAtIndex:(PreviewScrollView*)scrollView index:(int)index;
-(int)itemCount:(PreviewScrollView*)scrollView;
-(void)pageChanged:(NSInteger)note;
@end
 
 
@interface PreviewScrollView : UIView<UIScrollViewDelegate> {
	UIScrollView *scrollView;	
	id<PreviewScrollViewDelegate, NSObject> delegate;
	NSInteger lastPage;
	BOOL firstLayout;
	CGSize pageSize;
	BOOL dropShadow;
}
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) id<PreviewScrollViewDelegate, NSObject> delegate;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) BOOL dropShadow;

- (id)initWithFrameAndPageSize:(CGRect)frame pageSize:(CGSize)size;
- (void)selectPage:(NSInteger)index;
- (void)reload;

@end