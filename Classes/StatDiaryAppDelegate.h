//
//  StatDiaryAppDelegate.h
//  StatDiary
//
//  Created by Peter Arato on 6/5/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyDataNavigationController;

@interface StatDiaryAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	MyDataNavigationController *myDataNavigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MyDataNavigationController *myDataNavigationController;

@end

