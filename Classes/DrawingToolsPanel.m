//
//  DrawingToolsPanel.m
//  Remindly
//
//  Created by Nathan Stitt on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DrawingToolsPanel.h"
#import "ColorButton.h"

@implementation DrawingToolsPanel

-(void)makeTopButton:(UIColor*)c{
	ColorButton *b = [[ ColorButton alloc ] initWithColor: c ];
    b.frame = lastPos;
	[ b addTarget:self action:@selector(colorSelected:) forControlEvents:UIControlEventTouchUpInside ];
    [ self addSubview: b ];
    [ colorButtons addObject:b ];
    lastPos.origin.x += lastPos.size.width;
}


- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 480, 320, 320)];
    if (self) {
        self.backgroundColor = [ UIColor lightGrayColor ];

        lastPos = CGRectMake(0, 0, 25, 25);
        colorButtons = [[ NSMutableArray alloc ] init ];

        [ self makeTopButton:[UIColor blackColor] ];
        [ self makeTopButton:[UIColor darkGrayColor ] ];
        [ self makeTopButton:[UIColor lightGrayColor ] ];
        [ self makeTopButton:[UIColor grayColor ] ];
        [ self makeTopButton:[UIColor redColor ] ];
        [ self makeTopButton:[UIColor greenColor ] ];
        [ self makeTopButton:[UIColor blueColor ] ];
        [ self makeTopButton:[UIColor cyanColor ] ];
        [ self makeTopButton:[UIColor yellowColor ] ];
        [ self makeTopButton:[UIColor magentaColor ] ];
        [ self makeTopButton:[UIColor orangeColor ] ];
        [ self makeTopButton:[UIColor purpleColor ] ];
        [ self makeTopButton:[UIColor brownColor ] ];
    }
    return self;
}


-(void)setIsShowing:(BOOL)v {
	CGRect frame = self.frame;
   
	if ( v ){
		frame.origin.y = 260;
	} else {
		frame.origin.y = 480;
	}
    [UIView animateWithDuration:0.4f animations:^{   self.frame = frame;  }
                     completion:^ (BOOL finished) { self.superview.frame = [UIScreen mainScreen].applicationFrame; }];
    
}


-(BOOL)isShowing{
	return ( self.frame.origin.y < 420 );
}


- (void)dealloc
{
    [ colorButtons release ];
    [super dealloc];
}

@end
