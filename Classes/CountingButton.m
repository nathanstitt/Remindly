//
//  CountingButton.m
//  Mr Naggles
//
//  Created by Nathan Stitt on 12/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CountingButton.h"


@implementation CountingButton

@synthesize button;

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
