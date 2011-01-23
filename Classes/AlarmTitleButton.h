//
//  AlarmTitleButton.h
//  Created by Nathan Stitt on 11/29/10.
//  Copyright 2011.
//  Distributed under the terms of the GNU General Public License version 3.

// the AlarmTitleButton was originally a UILabel with rounded
// bottom border and drop shadow to make it appear offset
// on the DrawingView. 

// However after observing people using Remindly, I noticed that they consistently 
// tapped the label expecting it to set the alarm.  Rather than fight it, I gave them what
// they expected and changed it to a UIButton and pop up the alarm on TouchUpInside

#import <UIKit/UIKit.h>

@interface AlarmTitleButton : UIButton {
	CGFloat borderWidth;
	CGFloat borderRadius;
	UIColor *borderColor;
	// super's backgroundColor seems to always draw and I 
	// couldn't figure out how to stop that. Use this instead
	UIColor *fillColor;    
	
}
@property (nonatomic, copy) NSString*text;

@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat borderRadius;
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, retain) UIColor *fillColor;


@end
