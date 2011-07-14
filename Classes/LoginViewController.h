//
//  LoginViewController.h
//  StatDiary
//
//  Created by Peter Arato on 6/6/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC/XMLRPCConnectionDelegate.h>


#define KEEP_ME_LOGGED_IN_YES 1
#define KEEP_ME_LOGGED_IN_NO 2
#define KEEP_ME_LOGGED_IN_USERNAME @"keepMeLoggedInUserName"
#define KEEP_ME_LOGGED_IN_PASSWORD @"keepMeLoggedInPassword"
#define KEEP_ME_LOGGED_IN @"keepMeLoggedIn"

@class XMLRPCRequest;
@class StatListController;
@class IndicatorViewController;

@interface LoginViewController : UIViewController <XMLRPCConnectionDelegate, UIAlertViewDelegate> {
	IBOutlet UITextField *userNameField;
	IBOutlet UITextField *passwordField;
	IBOutlet UISwitch *keepMeLoggedInSwitch;
	IBOutlet UIButton *loginButton;
	
	StatListController *statListController;
	
	XMLRPCRequest *connectionRequest;
	XMLRPCRequest *loginRequest;
	
	IndicatorViewController *networkIndicator;
}

@property (nonatomic, retain) IBOutlet UITextField *userNameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) XMLRPCRequest *connectionRequest;
@property (nonatomic, retain) XMLRPCRequest *loginRequest;
@property (nonatomic, retain) StatListController *statListController;
@property (nonatomic, retain) IndicatorViewController *networkIndicator;
@property (nonatomic, retain) IBOutlet UISwitch *keepMeLoggedInSwitch;

- (IBAction)onPressLoginButton:(id)sender;
- (void)loadStatList;
- (void)connect;
- (void)connectWithDelay;
- (BOOL)getKeepMeSignedIn;
- (void)setKeepMeSignedIn:(BOOL)value;
- (void)changeKeepMeLoggedInSwitch:(id)sender;
- (IBAction)onPressDoneKey:(id)sender;

@end
