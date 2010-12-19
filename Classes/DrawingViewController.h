//
//  DrawingView.h
//  IoGee
//
//  Created by Nathan Stitt on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientButton.h"

@class MainViewController,AlarmTitleLabel,Note;

@interface DrawingViewController : UIViewController {
	CGPoint lastPoint;
	CGPoint points[5];
	MainViewController *mainView;
	UIImageView *drawImage;
	Note *note;
	BOOL isErasing;
	BOOL wasMoved;
	AlarmTitleLabel *alarmLabel;
	int mouseMoved;
	CGColorRef color;
}

- (id)initWithMainView:(MainViewController*)mv;
- (void)clear;
- (void)noteUpdated;

@property (nonatomic) BOOL hidden;
@property (nonatomic) CGColorRef color;
@property (nonatomic,retain) Note* note;
@property (nonatomic) BOOL isErasing;
@end
