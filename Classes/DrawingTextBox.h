


#import "HPGrowingTextView.h"

@interface DrawingTextBox : HPGrowingTextView {
	UIImage *placardImage;
	
	NSString *currentDisplayString;
	CGFloat fontSize;
	CGSize textSize;
//	RoundedTextView *textView;
	NSArray *displayStrings;
	NSUInteger displayStringsIndex;
	CGPoint displacedFrom;
}

@property (nonatomic) BOOL isEditing;

// Initializer for this object
- (id)init;
- (void)liftUp;
- (void)moveTo:(CGPoint)point;
- (void)moveToAndDrop:(CGPoint)point;
@end
