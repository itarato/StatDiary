//
//  AccountTabController.h
//  StatDiary
//
//  Created by Peter Arato on 7/2/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;
@class RegistrationViewController;

@interface WelcomeViewController : UIViewController {
	LoginViewController *loginViewController;
	RegistrationViewController *registrationViewController;
}

@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, retain) RegistrationViewController *registrationViewController;

- (void)onRegistrationIsComplete:(NSNotification *)notification;
- (IBAction)pressLoginButton:(id)sender;
- (IBAction)pressRegisterButton:(id)sender;

@end
