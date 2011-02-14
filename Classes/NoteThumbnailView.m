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

#import "NoteThumbnailView.h"
#import "NoteSelectorController.h"

#import <QuartzCore/QuartzCore.h>

@implementation NoteThumbnailView

@synthesize note;

-(id)initWithNote:(Note*)n frame:(CGRect)frame scroller:(NotesScrollView*)sc {
	scroller = sc;
	self = [ super initWithFrame:frame ];

	note = n;
	imageView = [[UIImageView alloc ] initWithFrame:CGRectMake(10, 10, frame.size.width-20, self.frame.size.height-20) ];
	imageView.backgroundColor = [ UIColor whiteColor ];
	imageView.image = [ note thumbnail ];
	[imageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
	[imageView.layer setBorderWidth: 1.0];
	imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
	imageView.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
	imageView.layer.shadowOpacity = 1.0f;
	imageView.layer.shadowRadius = 10.0f;
	[self addSubview:imageView];

	deleteBtn = [ UIButton buttonWithType: UIButtonTypeCustom ];
	deleteBtn.frame = CGRectMake( frame.size.width-28, 0, 33, 33 );
//	deleteBtn.hidden = YES;
	[ self addSubview:deleteBtn ];
	
	[ deleteBtn retain ];
	[ deleteBtn setImage:[ UIImage imageNamed:@"delete_icon" ] forState:UIControlStateNormal ] ;
	[ deleteBtn addTarget:self action:@selector(deletePressed:) forControlEvents:UIControlEventTouchUpInside ];
	[ self addSubview:deleteBtn ];

	self.userInteractionEnabled = YES;

	self.contentMode = UIViewContentModeScaleToFill;
	return self;
}


-(void) setFocused:(BOOL) s {
	if ( s ){
		deleteBtn.hidden = NO;
	} else {
		deleteBtn.hidden = YES;
	}
}


-(BOOL) focused {
	return ! deleteBtn.hidden;
}


-(void)deletePressed:(id)btn{
	[ scroller deleteThumbnail:self ];
}


-(void) setNote:(Note*)n {
	if ( n != note ){
		[ note release ];
		[ n retain ];
		note=n;
	}
	imageView.image = [note thumbnail];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[ scroller noteWasSelected: note ];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[ deleteBtn release  ];
	[ imageView release  ];
	[ super dealloc      ];
}
 
@end

