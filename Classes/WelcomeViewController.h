//
//  AccountTabController.h
//  StatDiary
//
//  Created by Peter Arato on 7/2/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC/XMLRPCRequest.h>
#import <XMLRPC/XMLRPCConnectionDelegate.h>
#import "XMLRPCRequestExtended.h"
#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "IndicatorViewController.h"


@class StatListController;


@interface WelcomeViewController : UIViewController <XMLRPCConnectionDelegate> {
	LoginViewController *loginViewController;
	RegistrationViewController *registrationViewController;
	StatListController *statListController;
	
	XMLRPCRequestExtended *connectionRequest;
	XMLRPCRequest *infoRequest;
	IndicatorViewController *networkIndicator;
}


@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, retain) RegistrationViewController *registrationViewController;
@property (nonatomic, retain) StatListController *statListController;
@property (nonatomic, retain) XMLRPCRequestExtended *connectionRequest;
@property (nonatomic, retain) IndicatorViewController *networkIndicator;
@property (nonatomic, retain) XMLRPCRequest *infoRequest;


- (void)onRegistrationIsComplete:(NSNotification *)notification;
- (IBAction)pressLoginButton:(id)sender;
- (IBAction)pressRegisterButton:(id)sender;
- (void)connect;
- (void)connectWithDelay;
- (void)openLoginView;


@end
