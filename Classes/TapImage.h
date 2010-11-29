//
//  TapImage.h
//
//  Created by Björn Sållarp on 7/14/10.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import <Foundation/Foundation.h>
#import "Note.h"

@class ScrollController;

@interface TapImage : UIView {
	Note *note;
	UIImageView *imageView;
	ScrollController *scroller;
}

-(id)initWithNote:(Note*)n frame:(CGRect)frame scroller:(ScrollController*)sc;
-(void)reload;

@property (nonatomic,retain) Note *note;

@end
