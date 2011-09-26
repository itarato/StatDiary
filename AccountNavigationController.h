//
//  AccountNavigationController.h
//  StatDiary
//
//  Created by Peter Arato on 9/26/11.
//  Copyright (c) 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WelcomeViewController.h"

@interface AccountNavigationController : UINavigationController {
	WelcomeViewController *welcomeViewController;
}

@property (nonatomic, retain) WelcomeViewController *welcomeViewController;

@end
