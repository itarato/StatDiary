//
//  LoginViewController.h
//  StatDiary
//
//  Created by Peter Arato on 6/6/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC/XMLRPCConnectionDelegate.h>


//#define KEEP_ME_LOGGED_IN_YES 1
//#define KEEP_ME_LOGGED_IN_NO 2
#define LOGGED_IN_USERNAME @"keepMeLoggedInUserName"
#define LOGGED_IN_PASSWORD @"keepMeLoggedInPassword"
//#define KEEP_ME_LOGGED_IN @"keepMeLoggedIn"

@class XMLRPCRequest;
@class StatListController;
@class IndicatorViewController;

@interface LoginViewController : UITableViewController <XMLRPCConnectionDelegate, UIAlertViewDelegate, UITextFieldDelegate> {
	IBOutlet UITextField *userNameField;
	IBOutlet UITextField *passwordField;
//	IBOutlet UISwitch *keepMeLoggedInSwitch;
	IBOutlet UITableViewCell *userNameCell;
	IBOutlet UITableViewCell *passwordCell;
//	IBOutlet UITableViewCell *keepMeLoggedInCell;
//	StatListController *statListController;
	XMLRPCRequest *loginRequest;
	IndicatorViewController *networkIndicator;
}

@property (nonatomic, retain) IBOutlet UITextField *userNameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
//@property (nonatomic, retain) IBOutlet UISwitch *keepMeLoggedInSwitch;
@property (nonatomic, retain) XMLRPCRequest *loginRequest;
//@property (nonatomic, retain) StatListController *statListController;
@property (nonatomic, retain) IndicatorViewController *networkIndicator;
@property (nonatomic, retain) UITableViewCell *userNameCell;
@property (nonatomic, retain) UITableViewCell *passwordCell;
//@property (nonatomic, retain) UITableViewCell *keppMeLoggedInCell;

//- (void)onPressLoginButton:(id)sender;
- (void)loadStatList;
//- (BOOL)getKeepMeSignedIn;
//- (void)setKeepMeSignedIn:(BOOL)value;
//- (void)changeKeepMeLoggedInSwitch:(id)sender;

//- (IBAction)pressReturnKey:(id)sender;

+ (void)popUpLoginOn:(UIViewController *)viewController;

@end
