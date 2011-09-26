//
//  AccountTabController.h
//  StatDiary
//
//  Created by Peter Arato on 7/2/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC/XMLRPCConnectionDelegate.h>

@class LoginViewController;
@class RegistrationViewController;
@class XMLRPCRequest;
@class IndicatorViewController;
@class StatListController;

@interface WelcomeViewController : UIViewController <XMLRPCConnectionDelegate> {
	LoginViewController *loginViewController;
	RegistrationViewController *registrationViewController;
	StatListController *statListController;
	
	XMLRPCRequest *connectionRequest;
	IndicatorViewController *networkIndicator;
}

@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, retain) RegistrationViewController *registrationViewController;
@property (nonatomic, retain) StatListController *statListController;
@property (nonatomic, retain) XMLRPCRequest *connectionRequest;
@property (nonatomic, retain) IndicatorViewController *networkIndicator;

- (void)onRegistrationIsComplete:(NSNotification *)notification;
- (IBAction)pressLoginButton:(id)sender;
- (IBAction)pressRegisterButton:(id)sender;
- (void)connect;
- (void)connectWithDelay;
- (void)openLoginView;

@end
