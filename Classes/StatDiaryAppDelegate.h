//
//  StatDiaryAppDelegate.h
//  StatDiary
//
//  Created by Peter Arato on 6/5/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ApplicationViewController;

@interface StatDiaryAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	ApplicationViewController *applicationViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ApplicationViewController *applicationViewController;

@end

