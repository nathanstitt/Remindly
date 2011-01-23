//
//  NSDate+HumanInterval.h
//  Copyright 2011 Nathan Stitt,
//  Distributed under the terms of the GNU General Public License version 3.
//  
//  A category adding a humanIntervalFromNow method to NSDate

#import <UIKit/UIKit.h>

@interface NSDate (HumanInterval)
- (NSString *) humanIntervalFromNow;
@end
