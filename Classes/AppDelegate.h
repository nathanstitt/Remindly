
//  AppDelegate.h

//  Created by Nathan Stitt on 11/6/10.
//  Copyright 2011.
//  Distributed under the terms of the GNU General Public License version 3.

// Since I dislike Interface builder's Xib's the 
// app is composed entirely from code.  Accordingly the ApplicationDelegate is 
// a bit more complex than normal, as it handles creating the window and views


#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "Note.h"
#import "PurchaseManager.h"

@interface AppDelegate : NSObject <UIApplicationDelegate,UIAlertViewDelegate> {
    UIWindow *window;
	MainViewController *mvc;
	Note *pendingNote;
}

@end

