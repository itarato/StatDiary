//
//  MyDataNavigationController.h
//  StatDiary
//
//  Created by Peter Arato on 6/8/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StatListController;

@interface MyDataNavigationController : UINavigationController {
	StatListController *statListController;
}

@property (nonatomic, retain) StatListController *statListController;

@end
