
#import "DrawingTextBox.h"
#import <QuartzCore/QuartzCore.h>

@implementation DrawingTextBox

- (id)init {
	// Retrieve the image for the view and determine its size

//	CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
	CGRect frame = CGRectMake( 100, 100, 120, 50 );
	
	if (self = [self initWithFrame:frame]) {
		self.internalTextView.userInteractionEnabled = NO;
		self.maxNumberOfLines = 20;
		self.minNumberOfLines = 3;

		self.internalTextView.backgroundColor = [ UIColor clearColor ];
		self.layer.borderWidth = 1.0;
		self.layer.cornerRadius =10;
		[[self layer] setBorderColor:
		[[UIColor grayColor] CGColor]];
		[[self layer] setBorderWidth:2.75];
		self.backgroundColor = [ UIColor whiteColor ];
		self.opaque = NO;
	}
	return self;
}

#define GROW_ANIMATION_DURATION_SECONDS 0.15
#define SHRINK_ANIMATION_DURATION_SECONDS 0.15

- (void)liftUp {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
	CGAffineTransform transform = CGAffineTransformMakeScale(1.2, 1.2);
	self.transform = transform;
	[UIView commitAnimations];

	[self setAlpha:1];
	[[self layer] setShadowColor:[UIColor blackColor].CGColor];
	[[self layer] setShadowOpacity:1.0f];
	[[self layer] setShadowRadius:6.0f];
	[[self layer] setShadowOffset:CGSizeMake(0, 3)];
	
}



#define KEYBOARD_SIZE 200

-(BOOL)isEditing{
	return self.isEditable;
}

-(void) setIsEditing:(BOOL)v {
	if ( v ){
		if ( ( self.frame.origin.y + self.frame.size.height ) > KEYBOARD_SIZE ){
			displacedFrom = self.center;
			CGRect f = self.frame;
			f.origin.y = 100;
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
			self.frame = f;
			[UIView commitAnimations];
		} else {
			displacedFrom = CGPointZero;
		}
		self.internalTextView.userInteractionEnabled = YES;
		[ self.internalTextView becomeFirstResponder ];
		//[textView becomeFirstResponder];
	} else {
		if ( ! CGPointEqualToPoint(CGPointZero, displacedFrom ) ){
			self.center = displacedFrom;
		}
		[ self.internalTextView  resignFirstResponder ];
		self.internalTextView.userInteractionEnabled = NO;
		
				
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS+GROW_ANIMATION_DURATION_SECONDS ];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
		CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 1.0);
		self.transform = transform;
		[UIView commitAnimations];

		[[self layer] setShadowColor:[UIColor clearColor].CGColor];
		[[self layer] setShadowRadius:0.0f];
		[[self layer] setShadowOffset:CGSizeMake(0, 0)];	
	
		//		textView.userInteractionEnabled = NO;
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

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS+GROW_ANIMATION_DURATION_SECONDS ];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(growAnimationDidStop:finished:context:)];
	CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 1.0);
	self.transform = transform;
	[UIView commitAnimations];

	
	[self setAlpha:1];
	[[self layer] setMasksToBounds:NO];
	[[self layer] setShadowColor:[UIColor clearColor].CGColor];
	[[self layer] setShadowOpacity:1.0f];
	[[self layer] setShadowRadius:0.0f];
	[[self layer] setShadowOffset:CGSizeMake(0, 0)];	
	
}

- (void)growAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:SHRINK_ANIMATION_DURATION_SECONDS];
	self.transform = CGAffineTransformMakeScale(1.1, 1.1);	
	[UIView commitAnimations];
}

- (void)dealloc {
	[placardImage release];
	[currentDisplayString release];
	[displayStrings release];
	[super dealloc];
}




@end
