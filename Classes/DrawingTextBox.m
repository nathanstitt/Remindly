
#import "DrawingTextBox.h"
#import <QuartzCore/QuartzCore.h>
#import "NotesManager.h"
@implementation DrawingTextBox

- (id)initWithTextBlob:(NoteTextBlob*)n {

	CGRect frame = CGRectEqualToRect(CGRectZero, n.frame) ? CGRectMake( 80, 30 * n.note.textBlobs.count, 160, 28 ) : n.frame;

	if ( ( self = [self initWithFrame: frame ]) ) {
		ntb = n;
		[ ntb retain ];
		
		deleteBtn = [ UIButton buttonWithType: UIButtonTypeCustom ];
		[ deleteBtn retain ];
		deleteBtn.frame = CGRectMake( frame.size.width-24, 0, 65, 65 );
		[ deleteBtn setImage:[ UIImage imageNamed:@"delete_icon" ] forState:UIControlStateNormal ] ;
		[ deleteBtn addTarget:self action:@selector(deletePressed:) forControlEvents:UIControlEventTouchUpInside ];

		self.internalTextView.userInteractionEnabled = NO;
		self.internalTextView.font = [ UIFont systemFontOfSize: 22 ];
        self.internalTextView.textAlignment = UITextAlignmentCenter;
		self.maxNumberOfLines = 20;
		self.minNumberOfLines = 1;

		self.internalTextView.backgroundColor = [ UIColor clearColor ];
		self.layer.borderWidth = 1.0;
		self.layer.cornerRadius =10;
		[ self.layer setBorderColor: [[UIColor grayColor] CGColor]];
		[ self.layer setBorderWidth:2.75];
		self.backgroundColor = [ UIColor whiteColor ];
		self.opaque = NO;
		
		self.text = ntb.text;
		self.animateHeightChange = YES;
		[ self textViewDidChange:self.internalTextView ];
		self.animateHeightChange = NO;
	}
	return self;
}

-(void)deletePressed:(id)sel {
	[ ntb remove ];
	[ deleteBtn removeFromSuperview ];
	[ self removeFromSuperview ];
}

#define GROW_ANIMATION_DURATION_SECONDS 0.15
#define SHRINK_ANIMATION_DURATION_SECONDS 0.15

- (void)liftUp {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];

//	CGAffineTransform transform = CGAffineTransformMakeScale(1.2, 1.2);
//	self.transform = transform;
//	[UIView commitAnimations];

	[self setAlpha:1];
	[[self layer] setShadowColor:[UIColor blackColor].CGColor];
	[[self layer] setShadowOpacity:1.0f];
	[[self layer] setShadowRadius:6.0f];
	[[self layer] setShadowOffset:CGSizeMake(0, 3)];

}

-(void)drop {
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS+GROW_ANIMATION_DURATION_SECONDS ];
//	CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 1.0);
//	self.transform = transform;
//	[UIView commitAnimations];
	
	ntb.frame = self.frame;
	
}


#define KEYBOARD_SIZE 200

-(BOOL)isEditing{
	return self.isEditable;
}

-(void)showDelButton {
	CGRect frame = CGRectMake( self.frame.origin.x+self.frame.size.width-14, self.frame.origin.y-10, 30, 30 );
	[UIView animateWithDuration:GROW_ANIMATION_DURATION_SECONDS
			                          animations:^{ deleteBtn.frame = frame; }
			                          completion:^(BOOL finished)
	 { [ self.superview addSubview: deleteBtn ]; } ];
}

-(void) setIsEditing:(BOOL)v {
	if ( v ){
		if ( ( self.frame.origin.y + self.frame.size.height ) > KEYBOARD_SIZE ){
			displacedFrom = self.center;
			CGRect f = self.frame;
			f.origin.y = 100;
			[UIView animateWithDuration:GROW_ANIMATION_DURATION_SECONDS
			                          animations:^{ self.frame = f; }
			                          completion:^(BOOL finished)
			 { [ self showDelButton ]; }];
		} else {
			
				[ self showDelButton ];
			
		}

		self.internalTextView.userInteractionEnabled = YES;
		[ self.internalTextView becomeFirstResponder ];
	} else {
		if ( ! CGPointEqualToPoint(CGPointZero, displacedFrom ) ){

			[UIView animateWithDuration:GROW_ANIMATION_DURATION_SECONDS
							 animations:^{ self.center = displacedFrom; }
							 completion:^(BOOL finished){  } ];
			
		}
		[ self.internalTextView  resignFirstResponder ];
		self.internalTextView.userInteractionEnabled = NO;
		ntb.text = self.text;
		[ self drop ];
		[  deleteBtn removeFromSuperview ];
		[[self layer] setShadowColor:[UIColor clearColor].CGColor];
		[[self layer] setShadowRadius:0.0f];
		[[self layer] setShadowOffset:CGSizeMake(0, 0)];	
	}
}

-(void)moveTo:(CGPoint)point{
	self.center = point;
}


-(void)moveToAndDrop:(CGPoint)point {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:SHRINK_ANIMATION_DURATION_SECONDS];
	self.center = point;
	[UIView commitAnimations];

	[ self drop ];
	
	[self setAlpha:1];
	[[self layer] setMasksToBounds:NO];
	[[self layer] setShadowColor:[UIColor clearColor].CGColor];
	[[self layer] setShadowOpacity:1.0f];
	[[self layer] setShadowRadius:0.0f];
	[[self layer] setShadowOffset:CGSizeMake(0, 0)];	
}



- (void)dealloc {
	[ ntb release ];
	[ deleteBtn release ];
	[placardImage release];
	[currentDisplayString release];
	[displayStrings release];
	[super dealloc];
}




@end
