//
//  AccountTabController.h
//  StatDiary
//
//  Created by Peter Arato on 7/2/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <XMLRPC/XMLRPCConnectionDelegate.h>

@class XMLRPCRequestExtended, IndicatorViewController, RegistrationViewController;
//@class XMLRPCRequest;
@class StatListController;


@interface WelcomeViewController : UIViewController <XMLRPCConnectionDelegate, UITableViewDataSource, UITableViewDelegate> {
	RegistrationViewController *registrationViewController;
	StatListController *statListController;
	
	XMLRPCRequestExtended *connectionRequest;
	XMLRPCRequest *infoRequest;
	XMLRPCRequest *loginRequest;
	IndicatorViewController *networkIndicator;
	
	UITableViewCell *usernameCell;
	UITableViewCell *passwordCell;
	
	UITextField *userNameField;
	UITextField *passwordField;
	
	UIButton *loginButton;
}


@property (nonatomic, retain) RegistrationViewController *registrationViewController;
@property (nonatomic, retain) StatListController *statListController;
@property (nonatomic, retain) XMLRPCRequestExtended *connectionRequest;
@property (nonatomic, retain) IndicatorViewController *networkIndicator;
@property (nonatomic, retain) XMLRPCRequest *infoRequest;
@property (nonatomic, retain) IBOutlet UITableViewCell *usernameCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *passwordCell;
@property (nonatomic, retain) XMLRPCRequest *loginRequest;
@property (nonatomic, retain) IBOutlet UITextField *userNameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;


- (void)onRegistrationIsComplete:(NSNotification *)notification;
- (IBAction)pressLoginButton:(id)sender;
- (IBAction)pressRegisterButton:(id)sender;
- (void)connect;
- (void)connectWithDelay;
- (void)loadStatList;
- (void)login;
- (IBAction)onPressDoneKey:(id)sender;


@end
