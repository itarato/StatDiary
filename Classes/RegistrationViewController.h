//
//  RegistrationViewController.h
//  StatDiary
//
//  Created by Peter Arato on 6/17/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC/XMLRPCConnectionDelegate.h>


@interface RegistrationViewController : UIViewController <UIScrollViewDelegate, XMLRPCConnectionDelegate> {
	IBOutlet UITextField *userNameField;
	IBOutlet UITextField *passwordField;
	IBOutlet UITextField *passwordRetypeField;
	IBOutlet UITextField *emailField;
	IBOutlet UIButton    *registerButton;
    CGPoint defaultCenter;
}

@property (nonatomic, retain) IBOutlet UITextField *userNameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UITextField *passwordRetypeField;
@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UIButton    *registerButton;

- (IBAction)onEnterTextField:(id)sender;
- (IBAction)onPressExitOnTextField:(id)sender;
- (void)swipeViewTo:(CGPoint)toPoint;

@end
