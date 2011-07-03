//
//  StatListController.h
//  StatDiary
//
//  Created by Peter Arato on 6/8/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC/XMLRPCConnectionDelegate.h>
#import "AccountTabController.h"
#import "CreateStatViewController.h"


@class StatDetailsViewController;
@class XMLRPCRequest;
@class IndicatorViewController;


@interface StatListController : UITableViewController <XMLRPCConnectionDelegate> {
	NSMutableArray *myStats;
	StatDetailsViewController *statDetailsViewController;
	XMLRPCRequest *myListRequest;
	XMLRPCRequest *logOutRequest;
	IndicatorViewController *networkIndicator;
	AccountTabController *accountController;
    CreateStatViewController *createStatViewController;
}

@property (nonatomic, retain) NSMutableArray *myStats;
@property (nonatomic, retain) StatDetailsViewController *statDetailsViewController;
@property (nonatomic, retain) XMLRPCRequest *myListRequest;
@property (nonatomic, retain) XMLRPCRequest *logOutRequest;
@property (nonatomic, retain) IndicatorViewController *networkIndicator;
@property (nonatomic, retain) AccountTabController *accountController;
@property (nonatomic, retain) CreateStatViewController *createStatViewController;

- (void)reloadStatData;
- (void)onSuccessLogin:(NSNotification *)notification;
- (void)logout;
- (void)onPressAddStatButton;
- (void)onRefreshRequest:(NSNotification *)notification;

+ (NSString *)elapsedTimeFromTimestamp:(NSNumber *)timestamp;

@end
