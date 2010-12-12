//
//  TapImage.m
//
//  Created by Björn Sållarp on 7/14/10.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import "NotePreviewView.h"
#import "ScrollController.h"

@implementation NotePreviewView

@synthesize note;

-(id)initWithNote:(Note*)n frame:(CGRect)frame scroller:(ScrollController*)sc {
	scroller = sc;
	self = [ super initWithFrame:frame ];
	
//	self.backgroundColor = [ UIColor blueColor ];
	note = n;
	imageView = [[UIImageView alloc ] initWithFrame:CGRectMake(10, 10, frame.size.width-20, self.frame.size.height-20) ];
	imageView.backgroundColor = [ UIColor whiteColor ];
	imageView.image = note.image;
	self.userInteractionEnabled = YES;

	[imageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
	[imageView.layer setBorderWidth: 1.0];
	imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
	imageView.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
	imageView.layer.shadowOpacity = 1.0f;
	imageView.layer.shadowRadius = 10.0f;
	[self addSubview:imageView];
//	self.image = note.image;
	
	
	self.contentMode = UIViewContentModeScaleToFill;

	return self;
}

-(void) reload {	
	imageView.image = note.image;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"Touches began");
	[ scroller noteWasSelected: note ];
}

@end

