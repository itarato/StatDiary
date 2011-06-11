//
//  ApplicationViewController.h
//  StatDiary
//
//  Created by Peter Arato on 6/6/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyDataNavigationController;
@class LoginViewController;


@interface ApplicationViewController : UIViewController {
	MyDataNavigationController *myDataNavigationController;
	LoginViewController *loginViewController;
	
	NSString *userName;
	NSString *password;
	NSNumber *uid;
}

@property (nonatomic, retain) MyDataNavigationController *myDataNavigationController;
@property (nonatomic, retain) LoginViewController *loginViewController;

- (void)onSuccessConnection:(NSNotification *)notification;
- (void)onSuccessAuthentication:(NSNotification *)notification;

@end
