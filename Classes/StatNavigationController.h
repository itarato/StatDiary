//
//  MyDataNavigationController.h
//  StatDiary
//
//  Created by Peter Arato on 6/8/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatListController.h"
#import "AccountNavigationController.h"


@interface StatNavigationController : UINavigationController <UINavigationControllerDelegate> {
	StatListController *statListController;
	AccountNavigationController *accountNavigationController;
}

@property (nonatomic, retain) StatListController *statListController;
@property (nonatomic, retain) AccountNavigationController *accountNavigationController;

- (void)showLogin;

@end
