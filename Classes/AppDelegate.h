//
//  IoGeeAppDelegate.h
//  IoGee
//
//  Created by Nathan Stitt on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "Note.h"
#import "PurchaseManager.h"

@interface AppDelegate : NSObject <UIApplicationDelegate,UIAlertViewDelegate> {
    UIWindow *window;
	MainViewController *mvc;
	Note *pendingNote;
	PurchaseManager *purchaseManager;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

