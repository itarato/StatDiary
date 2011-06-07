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

@interface ApplicationViewController : UIViewController {
	SplashViewController *splashViewController;
	LoginViewController *loginViewController;
	
	NSString *sessionID;
	NSString *userName;
	NSString *password;
	int uid;
}

@property (nonatomic, retain) SplashViewController *splashViewController;
@property (nonatomic, retain) LoginViewController *loginViewController;

- (void)onSuccessConnection:(NSNotification *)notification;

@end
