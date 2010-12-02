//
//  DrawingColorManager.m
//  Mr Naggles
//
//  Created by Nathan Stitt on 12/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DrawingColorManager.h"
#import "MainViewController.h"
#import "ColorButton.h"

@implementation DrawingColorManager

@synthesize toolBar,delegate,pickerButton;

-(UIBarButtonItem*)makeBarButton:(UIColor*)c{
	ColorButton *b = [[ ColorButton alloc ] iniWithColor: c.CGColor ];
	[ b addTarget:self action:@selector(colorSelected:) forControlEvents:UIControlEventTouchUpInside ];
	UIBarButtonItem *bbt = [[UIBarButtonItem alloc ] initWithCustomView: b ];
	[ b release ];
	return [ bbt autorelease ];
}

-(id)initWithColor:(UIColor*)c{
	self = [ super init ];

	toolBar = [[UIToolbar alloc] init];
	toolBar.barStyle = UIBarStyleBlack;
	toolBar.frame = CGRectMake( 0, 420, 320, 50 );
	[ toolBar sizeToFit];
	
	toolBar.items = [NSArray arrayWithObjects:
					 [ self makeBarButton:[UIColor redColor ] ],
					 [ self makeBarButton:[UIColor blueColor ] ],
					 [ self makeBarButton:[UIColor yellowColor ] ],
					 [ self makeBarButton:[UIColor grayColor ] ],
					 [ self makeBarButton:[UIColor greenColor ] ],
					 [ self makeBarButton:[UIColor whiteColor ] ],
					 NULL ];
	
	
	pickerButton = [ self makeBarButton: c ];
	[ pickerButton retain ];
	[ ((ColorButton*)pickerButton.customView) removeTarget:self action:@selector(colorSelected:) forControlEvents:UIControlEventTouchUpInside ];
	
	[ ((ColorButton*)pickerButton.customView) addTarget:self action:@selector(toggleToolBar:) forControlEvents:UIControlEventTouchUpInside ];
	
	return self;
}

-(void)colorSelected:(ColorButton*)cv {
	self.selectedColor = [ cv color ];
	self.toolBarShowing = NO;
	if ( delegate ){
		[ delegate drawingColorManagerColorUpdated:self color:[cv color ] ];
	}
}

-(CGColorRef) selectedColor{
	return  ((ColorButton*)pickerButton.customView).color;
}

-(void)setSelectedColor:(CGColorRef)c{
	((ColorButton*)pickerButton.customView).color = c;	
}

-(BOOL)toolBarShowing{
	return 420 != toolBar.frame.origin.y;
}

-(void)setToolBarShowing:(BOOL)v {
	CGRect frame = toolBar.frame;
	if ( v ){
		frame.origin.y = frame.origin.y - frame.size.height; 
	} else {
		frame.origin.y = 420; 
	}
	[ UIView beginAnimations:nil context:NULL ];
	[ UIView setAnimationDuration:0.33f ];
	toolBar.frame = frame;
	[ UIView commitAnimations ];	
}

-(void) toggleToolBar:(id)sel{
	self.toolBarShowing = ! self.toolBarShowing;
}



- (void)dealloc {
	[ pickerButton release ];
	[ toolBar release ];
    [super dealloc];
}
@end
