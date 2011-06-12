//
//  StatListController.h
//  StatDiary
//
//  Created by Peter Arato on 6/8/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC/XMLRPCConnectionDelegate.h>

@class StatDetailsViewController;
@class LoginViewController;
@class XMLRPCRequest;
@class IndicatorViewController;

@interface StatListController : UITableViewController <XMLRPCConnectionDelegate> {
	NSMutableArray *myStats;
	StatDetailsViewController *statDetailsViewController;
	LoginViewController *loginViewController;
	XMLRPCRequest *myListRequest;
	XMLRPCRequest *logOutRequest;
	IndicatorViewController *networkIndicator;
}

@property (nonatomic, retain) NSMutableArray *myStats;
@property (nonatomic, retain) StatDetailsViewController *statDetailsViewController;
@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, retain) XMLRPCRequest *myListRequest;
@property (nonatomic, retain) XMLRPCRequest *logOutRequest;
@property (nonatomic, retain) IndicatorViewController *networkIndicator;

- (void)reloadStatData;
- (void)onSuccessLogin:(NSNotification *)notification;
- (void)logout;
+ (NSString *)elapsedTimeFromTimestamp:(NSNumber *)timestamp;

@end
