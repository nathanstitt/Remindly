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

#import "NotePreviewView.h"
#import "NoteSelectorController.h"

#import <QuartzCore/QuartzCore.h>

@implementation NotePreviewView

@synthesize note;

-(id)initWithNote:(Note*)n frame:(CGRect)frame scroller:(NotesScrollView*)sc {
	scroller = sc;
	self = [ super initWithFrame:frame ];

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

	self.contentMode = UIViewContentModeScaleToFill;

	return self;
}



-(void) setNote:(Note*)n {
	if ( n != note ){
		[ note release ];
		[ n retain ];
		note=n;
	}
	imageView.image = note.image;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"Touches began");
	[ scroller noteWasSelected: note ];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[ imageView release  ];
	[ super dealloc      ];
}
 
@end

