//
//  RegistrationViewController.h
//  StatDiary
//
//  Created by Peter Arato on 6/17/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC/XMLRPCConnectionDelegate.h>
#import "IndicatorViewController.h"


@interface RegistrationViewController : UITableViewController <XMLRPCConnectionDelegate> {
	IBOutlet UITextField *userNameField;
	IBOutlet UITextField *passwordField;
	IBOutlet UITextField *passwordRetypeField;
	IBOutlet UITextField *emailField;
	IBOutlet UIButton    *registerButton;
    CGPoint defaultCenter;
    IndicatorViewController *networkIndicator;
	
	IBOutlet UITableViewCell *userNameCell;
	IBOutlet UITableViewCell *emailCell;
	IBOutlet UITableViewCell *passwordCell;
	IBOutlet UITableViewCell *passworkRetypeCell;
}

@property (nonatomic, retain) IBOutlet UITextField *userNameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UITextField *passwordRetypeField;
@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UIButton *registerButton;
@property (nonatomic, retain) IndicatorViewController *networkIndicator;
@property (nonatomic, retain) UITableViewCell *userNameCell;
@property (nonatomic, retain) UITableViewCell *emailCell;
@property (nonatomic, retain) UITableViewCell *passwordCell;
@property (nonatomic, retain) UITableViewCell *passwordRetypeCell;

- (IBAction)onEnterTextField:(id)sender;
- (IBAction)onPressExitOnTextField:(id)sender;
- (void)swipeViewTo:(CGPoint)toPoint;
- (IBAction)onPressRegisterButton:(id)sender;

@end
