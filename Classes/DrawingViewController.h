//
//  DrawingView.h
//  IoGee
//
//  Created by Nathan Stitt on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesManager.h"
#import "AlarmTitleLabel.h"
#import "GradientButton.h"

@interface DrawingViewController : UIViewController {
	CGPoint lastPoint;
	CGPoint pointBeforeLast;
	UIImageView *drawImage;
	Note *note;
	BOOL isErasing;
	UILabel *alarmLabel;
	int mouseMoved;
	CGColorRef color;
}

- (void)clear;
- (void)noteUpdated;


@property (nonatomic) CGColorRef color;
@property (nonatomic,retain) Note* note;
@property (nonatomic) BOOL isErasing;
@end
