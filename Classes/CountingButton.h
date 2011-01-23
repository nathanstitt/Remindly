//
//  CountingButton.h
//  Created by Nathan Stitt on 12/3/10.
//  Copyright 2011.
//  Distributed under the terms of the GNU General Public License version 3.

// The CountingButton emulates the Button in safari which
// shows the number of webviews open

#import <Foundation/Foundation.h>


@interface CountingButton : UIBarButtonItem {
	UIButton *button;
	UIImage *icon;
	UIFont *font;
	NSInteger count;
}

// the count to start with
-(id)initWithCount:(NSInteger)count;

@property (nonatomic) NSInteger count;

@property (nonatomic,readonly) UIButton *button;

@end
