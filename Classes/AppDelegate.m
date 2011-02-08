//
//  AppDelegate.m
/*  This file is part of Remindly.

    Remindly is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3.

    Remindly is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Remindly.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "AppDelegate.h"
#import "MainViewController.h"
#import "NotesManager.h"
#import "PurchaseManager.h"
#import "LocationAlarmManager.h"

@implementation AppDelegate


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [ NotesManager startup ];
	[ LocationAlarmManager startup ];
	[ PurchaseManager startup ];

	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	if ( ! [ defs integerForKey:@"numberNotesAllowed" ] ){
		[ defs setInteger:2 forKey:@"numberNotesAllowed" ];
		[ defs synchronize ];
	}
 
	application.applicationIconBadgeNumber = 0;
 
	UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if ( notification ) {
        NSLog(@"Recieved Notification %@",notification);
		Note *note = [[ NotesManager instance ] noteWithDirectory:
					   [ notification.userInfo objectForKey:@"directory" ] ];
		if ( note ){
			[ mvc selectNote: note ];
		}
    }


    CGRect windowRect = CGRectMake(0, 0, 320, 480 );
    window = [[UIWindow alloc] initWithFrame:windowRect];    
	
	mvc = [[MainViewController alloc ] init ];
	mvc.view.frame = CGRectMake(0, 20, 320, 460 );
	
	[ window addSubview:mvc.view ];

    [ window makeKeyAndVisible];
    return YES;
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if ( buttonIndex ){
		[ mvc selectNote:pendingNote ];
	}
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

	application.applicationIconBadgeNumber = 0;

    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateInactive) {
		Note *note = [[ NotesManager instance ] noteWithDirectory:
					   [ notification.userInfo objectForKey:@"directory"]  ];
		if ( note ){
			[ mvc selectNote: note ];
        }
    } else {
		Note *note = [[ NotesManager instance ] noteWithDirectory:
					   [ notification.userInfo objectForKey:@"directory"]  ];
		if ( note ){
			pendingNote = note;
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alarm expired"
												 message:notification.alertBody
												 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"View",NULL];
			[alert show];
			[alert release];	
		}
	}
}

	
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	[ mvc viewWillDisappear:NO ];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	application.applicationIconBadgeNumber = 0;

}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
