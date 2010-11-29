//
//  DrawingView.h
//  IoGee
//
//  Created by Nathan Stitt on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesManager.h"

@interface DrawingViewController : UIViewController {
	CGPoint lastPoint;
	CGPoint pointBeforeLast;
	UIImageView *drawImage;
	Note *note;
	BOOL mouseSwiped;
	UILabel *alarmLabel;
	int mouseMoved;
}


- (void)clear;
- (void)noteUpdated;
@property (nonatomic,retain) Note* note;

@end
