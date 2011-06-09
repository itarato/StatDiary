//
//  ApplicationViewController.h
//  StatDiary
//
//  Created by Peter Arato on 6/6/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SplashViewController;
@class LoginViewController;
@class MyDataNavigationController;

@interface ApplicationViewController : UIViewController {
	SplashViewController *splashViewController;
	LoginViewController *loginViewController;
	MyDataNavigationController *myDataNavigationController;
	
	NSString *userName;
	NSString *password;
	NSNumber *uid;
}

@property (nonatomic, retain) SplashViewController *splashViewController;
@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, retain) MyDataNavigationController *myDataNavigationController;

- (void)onSuccessConnection:(NSNotification *)notification;
- (void)onSuccessAuthentication:(NSNotification *)notification;

@end
