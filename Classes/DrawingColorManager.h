//
//  DrawingColorManager.h
//  Mr Naggles
//
//  Created by Nathan Stitt on 12/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DrawingColorManager;

@protocol DrawingColorManagerDelegate
@required
-(void)drawingColorManagerColorUpdated:(DrawingColorManager*)manager color:(CGColorRef)color;
@end
 

@class MainViewController,ColorButton;

@interface DrawingColorManager : NSObject {
	UIBarButtonItem *pickerButton;
	UIToolbar *toolBar;
	id<DrawingColorManagerDelegate> delegate;
	MainViewController *mvc;
}

-(id)initWithLastColor;
@property (nonatomic, retain) UIColor *selectedColor;
@property (nonatomic, assign ) id<DrawingColorManagerDelegate> delegate;
@property (nonatomic, readonly) UIToolbar *toolBar;
@property (nonatomic, readonly) UIBarButtonItem *pickerButton;
@property (nonatomic) BOOL toolBarShowing;
@end
