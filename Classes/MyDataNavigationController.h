//
//  MyDataNavigationController.h
//  StatDiary
//
//  Created by Peter Arato on 6/8/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StatListController;
@class LoginViewController;

@interface MyDataNavigationController : UINavigationController <UINavigationControllerDelegate> {
	StatListController *statListController;
	//LoginViewController *loginViewController;
	//UITabBarController *accountController;
}

@property (nonatomic, retain) StatListController *statListController;
//@property (nonatomic, retain) LoginViewController *loginViewController;
//@property (nonatomic, retain) UITabBarController *accountController;

@end
