//
//  StatListController.h
//  StatDiary
//
//  Created by Peter Arato on 6/8/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <XMLRPC/XMLRPCConnectionDelegate.h>
#import "StatCardDelegate.h"

@class StatDetailsViewController, IndicatorViewController, StatCardViewController, CreateStatViewController;
//@class XMLRPCRequest;

@interface StatListController : UIViewController <XMLRPCConnectionDelegate, UIScrollViewDelegate, StatCardDelegate, UIAlertViewDelegate> {
	NSMutableArray *myStats;
	StatDetailsViewController *statDetailsViewController;
	XMLRPCRequest *myListRequest;
	XMLRPCRequest *logOutRequest;
    XMLRPCRequest *deleteRequest;
	IndicatorViewController *networkIndicator;
    CreateStatViewController *createStatViewController;
	NSMutableArray *cards;
	UIAlertView *deleteConfirmAlert;

	IBOutlet UIScrollView *scrollView;
	IBOutlet UIPageControl *pageControl;
    
    StatCardViewController *lastSelectedCard;
}


@property (nonatomic, retain) NSMutableArray *myStats;
@property (nonatomic, retain) StatDetailsViewController *statDetailsViewController;
@property (nonatomic, retain) XMLRPCRequest *myListRequest;
@property (nonatomic, retain) XMLRPCRequest *logOutRequest;
@property (nonatomic, retain) XMLRPCRequest *deleteRequest;
@property (nonatomic, retain) IndicatorViewController *networkIndicator;
@property (nonatomic, retain) CreateStatViewController *createStatViewController;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *cards;
@property (nonatomic, retain) UIAlertView *deleteConfirmAlert;
@property (nonatomic, retain) StatCardViewController *lastSelectedCard;


- (void)reloadStatData;
- (void)onSuccessLogin:(NSNotification *)notification;
- (void)logout;
- (void)onPressAddStatButton;
- (void)onRefreshRequest:(NSNotification *)notification;
- (void)preprocessEntries;
- (void)rebuildCards;
- (IBAction)onPagerChanged:(id)sender;
//- (void)deleteStat;

+ (NSString *)elapsedTimeFromTimestamp:(NSNumber *)timestamp;


@end
