//
//  StatDiaryAppDelegate.h
//  StatDiary
//
//  Created by Peter Arato on 6/5/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatNavigationController.h"


@interface StatDiaryAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	StatNavigationController *statNavigationController;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet StatNavigationController *statNavigationController;


@end

