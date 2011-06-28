//
//  AccountViewController.h
//  StatDiary
//
//  Created by Peter Arato on 6/18/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;
@class RegistrationViewController;

@interface AccountViewController : UITabBarController {
	LoginViewController *loginViewController;
	RegistrationViewController *registrationViewController;
}

@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, retain) RegistrationViewController *registrationViewController;

@end
