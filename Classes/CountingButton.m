//
// CountingButton.m
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

#import "CountingButton.h"


@implementation CountingButton

@synthesize button,count;

-(id)initWithCount:(NSInteger)c{

    font = [UIFont boldSystemFontOfSize:13];
	icon = [ UIImage imageNamed:@"photos_icon.png" ];
	
	button = [ UIButton buttonWithType: UIButtonTypeCustom ];
    button.titleLabel.font = font;
    button.titleLabel.shadowOffset = CGSizeMake(0, -1);

    [ button setImage:icon forState:UIControlStateNormal ];
    [ button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [ button setTitleShadowColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [ button setBackgroundImage:[UIImage imageNamed:@"bar-button-item-background.png"] forState:UIControlStateNormal];

	button.frame = CGRectMake( 0, 0, icon.size.width + 15 + [ @"  " sizeWithFont:font].width, 30 );

	self = [ super initWithCustomView: button ];
	[ self setCount: c ];
	return self;
}

-(void)setCount:(NSInteger)c {
	NSString *cnt = [ NSString stringWithFormat:@"%ld", c ];
	CGSize size = [ cnt sizeWithFont: button.titleLabel.font ];
    button.titleEdgeInsets = UIEdgeInsetsMake( 0, ( -23 - size.width), 0, 0);
	[ button setTitle: cnt forState:UIControlStateNormal ];
}

- (void)dealloc {
	[ button release ];
    [super dealloc];
}

@end
