//
//  MyDataNavigationController.h
//  StatDiary
//
//  Created by Peter Arato on 6/8/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>


@class StatListController;
@class WelcomeViewController;


@interface MyDataNavigationController : UINavigationController <UINavigationControllerDelegate> {
	StatListController *statListController;
	WelcomeViewController *welcomeViewController;
}

@property (nonatomic, retain) StatListController *statListController;
@property (nonatomic, retain) WelcomeViewController *welcomeViewController;

@end
