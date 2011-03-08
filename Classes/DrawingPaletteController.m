//
//  DrawingToolsPanel.m
//  Remindly
//
//  Created by Nathan Stitt on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DrawingPaletteController.h"
#import <QuartzCore/QuartzCore.h> 
#import "ColorButton.h"
#import "UIColor+Expanded.h"
#import "DrawingPaletteTool.h"

@implementation DrawingPaletteController

@synthesize color,tool;

-(void)makeButton:(NSString*)c{
	ColorButton *b = [[ ColorButton alloc ] initWithColor: [UIColor colorWithName:c] ];
    b.frame = buttonFrame;
	[ b addTarget:self action:@selector(colorSelected:) forControlEvents:UIControlEventTouchUpInside ];
    [ self.view addSubview: b ];
    [ colorButtons addObject:b ];
}
-(void)makeTopButton:(NSString*)c{
    [ self makeButton:c ];
    buttonFrame.origin.x += buttonFrame.size.width+10;
}

-(id)init {
    self = [ super init ];
    if ( ! self ){
        return nil;
    }

    self.color = [ UIColor colorWithHexString:[ [NSUserDefaults standardUserDefaults] stringForKey:@"lastColorUsed" ] ];

    tools = [ NSArray arrayWithObjects:    
             [ DrawingPaletteTool withImage: [ UIImage imageNamed:@"brush_small_picker"  ] frame: CGRectMake(230, 50, 45,70) ],
             [ DrawingPaletteTool withImage: [ UIImage imageNamed:@"brush_medium_picker" ] frame: CGRectMake(170, 50, 45,70) ],
             [ DrawingPaletteTool withImage: [ UIImage imageNamed:@"brush_large_picker"  ] frame: CGRectMake(110, 50, 45,70) ],
             [ DrawingPaletteTool withImage: [ UIImage imageNamed:@"brush_xlarge_picker" ] frame: CGRectMake(50, 50, 45,70) ],
             NULL
             ];
    [tools retain];

    NSInteger w=0;
    for (DrawingPaletteTool *b in tools ){
        b.drawingWidth = ( w * 4 ) + 1;
        b.tag = w;
        w+=1;
    }

    NSInteger tindex = [ [NSUserDefaults standardUserDefaults] integerForKey: @"lastToolSelected" ];
    if ( tindex < [ tools count ] ){
        tool = [tools objectAtIndex:tindex ];
    }

    return self;
}

-(void)loadView {
    self.view = [[UIView alloc ] initWithFrame:CGRectMake(0, 480, 320, 320)];

    self.view.backgroundColor = [ UIColor colorWithHexString:@"9a9a9a" ];
    
    self.view.layer.cornerRadius = 45.0f;
    
    buttonFrame = CGRectMake( 26, 20, 25, 25);
    
    colorButtons = [[ NSMutableArray alloc ] init ];
    
    [ self makeTopButton: @"black" ];
    [ self makeTopButton: @"beige" ];
    [ self makeTopButton: @"aqua" ];
    [ self makeTopButton: @"blue"];
    [ self makeTopButton: @"blueviolet" ];
    [ self makeTopButton: @"brown" ];
    [ self makeTopButton: @"burlywood" ];
    [ self makeTopButton: @"cadetblue" ];
    
    buttonFrame = CGRectMake( 7, 50, 25, 25);
    [ self makeButton: @"chartreuse" ];
    
    buttonFrame = CGRectMake( 7, 85, 25, 25);
    [ self makeButton: @"chocolate" ];
    
    buttonFrame = CGRectMake( 7, 128, 25, 25);
    [ self makeButton: @"coral" ];
    
    [ self makeTopButton: @"cornflowerblue" ];
    [ self makeTopButton: @"crimson" ];
    [ self makeTopButton: @"darkblue" ];
    [ self makeTopButton: @"darkgray" ];
    [ self makeTopButton: @"darkgreen" ];
    [ self makeTopButton: @"navy" ];
    [ self makeTopButton: @"mediumpurple" ];
    [ self makeTopButton: @"olive" ];
    [ self makeTopButton: @"yellow" ];
    
    buttonFrame = CGRectMake( 285, 50, 25, 25);
    [ self makeTopButton: @"tomato" ];
    
    buttonFrame = CGRectMake( 285, 85, 25, 25);
    [ self makeTopButton: @"powderblue" ];
    
    
    for ( ColorButton *cb in colorButtons ){
        if ( [self.color isEqual: cb.color ] ){
            cb.marked = YES;
        } else {
            cb.marked = NO;
        }
    }
    
    for (DrawingPaletteTool *b in tools ){
        [ self.view addSubview: b ];
        b.selected = NO;
        [ b addTarget:self action:@selector(toolSelected:) forControlEvents:UIControlEventTouchUpInside ];
    }

    tool.selected = YES;
}

-(void)toolSelected:(DrawingPaletteTool*)t{
    if ( t == tool ){
        return;
    }
    for (DrawingPaletteTool *b in tools ){
        b.selected = NO;
    }
    self.tool = t;
    tool.selected = YES;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[ prefs setValue: [NSNumber numberWithInt: tool.tag ] forKey:@"lastToolSelected" ];
	[ prefs synchronize ];
}

-(void)colorSelected:(ColorButton*)cv{
    self.color = cv.color;
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[ prefs setValue:[ self.color hexStringFromColor] forKey:@"lastColorUsed" ];
	[ prefs synchronize ];
    for ( ColorButton *cb in colorButtons ){
        cb.marked = NO;
    }
    cv.marked = YES;
}


-(void)setIsShowing:(BOOL)v {
	CGRect frame = self.view.frame;
   
	if ( v ){
		frame.origin.y = 260;
	} else {
		frame.origin.y = 480;
	}
    [UIView animateWithDuration:0.4f animations:^{   self.view.frame = frame;  }
                     completion:^ (BOOL finished) { } ];
    
}


-(BOOL)isShowing{
	return ( self.isViewLoaded && self.view.frame.origin.y < 420 );
}


- (void)dealloc
{
    [ colorButtons release ];
    [super dealloc];
}

@end
