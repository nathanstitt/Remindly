//
//  CountingButton.h
//  Mr Naggles
//
//  Created by Nathan Stitt on 12/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CountingButton : UIBarButtonItem {
	UIButton *button;
	UIImage *icon;
	UIFont *font;
}

-(id)initWithCount:(NSInteger)count;
-(void)setCount:(NSInteger)count;


@property (nonatomic,readonly) UIButton *button;

@end
