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
#import "UIColor+FromToRGB.h"

@implementation DrawingColorManager

@synthesize toolBar,delegate,pickerButton,selectedColor;

-(UIBarButtonItem*)makeBarButton:(UIColor*)c{
	ColorButton *b = [[ ColorButton alloc ] iniWithColor: c.CGColor ];
	[ b addTarget:self action:@selector(colorSelected:) forControlEvents:UIControlEventTouchUpInside ];
	UIBarButtonItem *bbt = [[UIBarButtonItem alloc ] initWithCustomView: b ];
	[ b release ];
	return [ bbt autorelease ];
}

-(id)initWithLastColor {
	self = [ super init ];

	toolBar = [[UIToolbar alloc] init];
	toolBar.barStyle = UIBarStyleBlack;
	toolBar.frame = CGRectMake( 0, 420, 320, 50 );
	[ toolBar sizeToFit];
	
	toolBar.items = [NSArray arrayWithObjects:
					 [ self makeBarButton:[UIColor blackColor] ],
					 [ self makeBarButton:[UIColor darkGrayColor ] ],
					 [ self makeBarButton:[UIColor lightGrayColor ] ],
					 [ self makeBarButton:[UIColor grayColor ] ],
					 [ self makeBarButton:[UIColor redColor ] ],
					 [ self makeBarButton:[UIColor greenColor ] ],
					 [ self makeBarButton:[UIColor blueColor ] ],
					 [ self makeBarButton:[UIColor cyanColor ] ],
					 [ self makeBarButton:[UIColor yellowColor ] ],
					 [ self makeBarButton:[UIColor magentaColor ] ],
					 [ self makeBarButton:[UIColor orangeColor ] ],
					 [ self makeBarButton:[UIColor purpleColor ] ],
					 [ self makeBarButton:[UIColor brownColor ] ],
					 NULL ];
	
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSUInteger df =[ prefs doubleForKey:@"lastColorSelected" ];
	if ( ! df ){
		df = [[ UIColor darkGrayColor ] toRGBInt ];
		[prefs synchronize];
	}
	
	self.selectedColor = [ UIColor UIColorFromRGBInt:df ];
	pickerButton = [ self makeBarButton: self.selectedColor ];

	[ pickerButton retain ];
	[ ((ColorButton*)pickerButton.customView) removeTarget:self action:@selector(colorSelected:) forControlEvents:UIControlEventTouchUpInside ];
	
	[ ((ColorButton*)pickerButton.customView) addTarget:self action:@selector(toggleToolBar:) forControlEvents:UIControlEventTouchUpInside ];
	
	return self;
}

-(void)colorSelected:(ColorButton*)cv {
	self.selectedColor = [ UIColor colorWithCGColor: [ cv color ] ];
	((ColorButton*)pickerButton.customView).color = self.selectedColor.CGColor;
	self.toolBarShowing = NO;
	if ( delegate ){
		[ delegate drawingColorManagerColorUpdated:self color:self.selectedColor.CGColor];
	}
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[ prefs setInteger: [  self.selectedColor toRGBInt ] forKey:@"lastColorSelected"];
	[ prefs synchronize ];
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
