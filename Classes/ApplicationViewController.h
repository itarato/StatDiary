//
//  ApplicationViewController.h
//  StatDiary
//
//  Created by Peter Arato on 6/6/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@interface ApplicationViewController : UIViewController {

	LoginViewController *loginViewController;
	
}

@property (nonatomic, retain) LoginViewController *loginViewController;

@end
