//
//  AlarmTitleLabel.h
//  Mr Naggles
//
//  Created by Nathan Stitt on 11/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AlarmTitleLabel : UILabel {
	CGFloat borderWidth;
	CGFloat borderRadius;
	UIColor *borderColor;
	// super's backgroundColor seems to always draw and I 
	// couldn't figure out how to stop that. Use this instead
	UIColor *fillColor;    
	
}

@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat borderRadius;
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, retain) UIColor *fillColor;


@end
