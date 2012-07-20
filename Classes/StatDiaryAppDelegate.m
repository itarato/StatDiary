//
//  StatDiaryAppDelegate.m
//  StatDiary
//
//  Created by Peter Arato on 6/5/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#ifdef __APPLE__
#include "TargetConditionals.h"
#endif

#import "StatDiaryAppDelegate.h"
#import "StatNavigationController.h"
#import "Globals.h"

@implementation StatDiaryAppDelegate

@synthesize window;
@synthesize statNavigationController;


- (void)dealloc {
	[statNavigationController release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
    STATLOG(@"App init from %s", __FUNCTION__);
	
	[self.window makeKeyAndVisible];
	
	statNavigationController = [[StatNavigationController alloc] init];
	[self.window addSubview:statNavigationController.view];
	
    // No notifications for simulator.
#if !(TARGET_IPHONE_SIMULATOR)
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
	 (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#endif
    
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
	return YES;
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


#pragma mark Remote notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	STATLOG(@"Registered remote push notifications to %@", deviceToken);
	NSString *deviceTokenString = [[NSString alloc] initWithFormat:@"%@", deviceToken];
	[[Globals sharedInstance] setDeviceToken:deviceTokenString];
	[deviceTokenString release];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	STATLOG(@"Fail to register push notifications: %@ %s", error, __FUNCTION__);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Got notification when the app was open -> silent notification.
}

@end
