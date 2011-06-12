//
//  LoginViewController.h
//  StatDiary
//
//  Created by Peter Arato on 6/6/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC/XMLRPCConnectionDelegate.h>

@class XMLRPCRequest;
@class StatListController;
@class IndicatorViewController;

@interface LoginViewController : UIViewController <XMLRPCConnectionDelegate> {
	IBOutlet UITextField *userNameField;
	IBOutlet UITextField *passwordField;

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

- (IBAction)onPressLoginButton:(id)sender;
- (void)loadStatList;
- (void)connect;
- (void)connectWithDelay;

@end
