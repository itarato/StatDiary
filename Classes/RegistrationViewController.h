//
//  RegistrationViewController.h
//  StatDiary
//
//  Created by Peter Arato on 6/17/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegistrationViewController : UIViewController {
	IBOutlet UITextField *userNameField;
	IBOutlet UITextField *passwordField;
	IBOutlet UITextField *passwordRetypeField;
	IBOutlet UITextField *emailField;
	IBOutlet UIButton *registerButton;
}

@property (nonatomic, retain) IBOutlet UITextField *userNameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UITextField *passwordRetypeField;
@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UIButton    *registerButton;

@end
