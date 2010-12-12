
#import <Foundation/Foundation.h>
#import "Note.h"

@class ScrollController;

@interface NotePreviewView : UIView {
	Note *note;
	UIImageView *imageView;
	ScrollController *scroller;
}

-(id)initWithNote:(Note*)n frame:(CGRect)frame scroller:(ScrollController*)sc;
-(void)reload;

@property (nonatomic,retain) Note *note;

@end
