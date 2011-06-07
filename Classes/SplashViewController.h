//
//  SplashViewController.h
//  StatDiary
//
//  Created by Peter Arato on 6/7/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC/XMLRPCConnectionDelegate.h>

@interface SplashViewController : UIViewController <XMLRPCConnectionDelegate> {
	IBOutlet UIActivityIndicatorView *indicator;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

@end
