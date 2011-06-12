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

@interface LoginViewController : UIViewController <XMLRPCConnectionDelegate> {
	IBOutlet UITextField *userNameField;
	IBOutlet UITextField *passwordField;
	
	StatListController *statListController;
	
	XMLRPCRequest *connectionRequest;
	XMLRPCRequest *loginRequest;
}

@property (nonatomic, retain) IBOutlet UITextField *userNameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) XMLRPCRequest *connectionRequest;
@property (nonatomic, retain) XMLRPCRequest *loginRequest;
@property (nonatomic, retain) StatListController *statListController;

- (IBAction)onPressLoginButton:(id)sender;
- (void)loadStatList;
- (void)connect;
- (void)connectWithDelay;

@end
