//
//  DrawingToolsPanel.h
//  Remindly
//
//  Created by Nathan Stitt on 3/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DrawingPaletteTool;

@interface DrawingPaletteController : UIViewController {
    CGRect buttonFrame;
    NSMutableArray *colorButtons;
    UIColor *color;
    NSArray *tools;
    DrawingPaletteTool *tool;
}


@property (nonatomic) BOOL isShowing;
@property (nonatomic, assign ) DrawingPaletteTool *tool;
@property (nonatomic, retain ) UIColor *color;

@end
