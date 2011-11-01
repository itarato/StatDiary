//
//  StatListController.h
//  StatDiary
//
//  Created by Peter Arato on 6/8/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC/XMLRPCConnectionDelegate.h>
#import "CreateStatViewController.h"
#import <XMLRPC/XMLRPCRequest.h>
#import "StatDetailsViewController.h"
#import "IndicatorViewController.h"


@interface StatListController : UIViewController <XMLRPCConnectionDelegate, UITableViewDataSource, UITableViewDelegate> {
	NSMutableArray *myStats;
	StatDetailsViewController *statDetailsViewController;
	XMLRPCRequest *myListRequest;
	XMLRPCRequest *logOutRequest;
    XMLRPCRequest *deleteRequest;
	IndicatorViewController *networkIndicator;
    CreateStatViewController *createStatViewController;
	UITableView *listTable;
}


@property (nonatomic, retain) NSMutableArray *myStats;
@property (nonatomic, retain) StatDetailsViewController *statDetailsViewController;
@property (nonatomic, retain) XMLRPCRequest *myListRequest;
@property (nonatomic, retain) XMLRPCRequest *logOutRequest;
@property (nonatomic, retain) XMLRPCRequest *deleteRequest;
@property (nonatomic, retain) IndicatorViewController *networkIndicator;
@property (nonatomic, retain) CreateStatViewController *createStatViewController;
@property (nonatomic, retain) IBOutlet UITableView *listTable;


- (void)reloadStatData;
- (void)onSuccessLogin:(NSNotification *)notification;
- (void)logout;
- (void)onPressAddStatButton;
- (void)onRefreshRequest:(NSNotification *)notification;
- (void)preprocessEntries;


+ (NSString *)elapsedTimeFromTimestamp:(NSNumber *)timestamp;


@end
