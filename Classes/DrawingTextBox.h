


#import "HPGrowingTextView.h"
#import "Note.h"

@interface DrawingTextBox : HPGrowingTextView {
	UIImage *placardImage;
	NSString *currentDisplayString;
	CGFloat fontSize;
	CGSize textSize;
//	RoundedTextView *textView;
	NSArray *displayStrings;
	NSUInteger displayStringsIndex;
	CGPoint displacedFrom;
	NoteTextBlob *ntb;
	BOOL editAnimate;
	UIButton *deleteBtn;
}

@property (nonatomic) BOOL isEditing;

// Initializer for this object
- (id)initWithTextBlob:(NoteTextBlob*)ntb;
- (void)liftUp;
- (void)moveTo:(CGPoint)point;
- (void)moveToAndDrop:(CGPoint)point;
@end
