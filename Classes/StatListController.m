//
//  StatListController.m
//  StatDiary
//
//  Created by Peter Arato on 6/8/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import "StatListController.h"
#import <XMLRPC/XMLRPC.h>
#import "Globals.h"
#import "StatDetailsViewController.h"
#import "IndicatorViewController.h"
#import "WelcomeViewController.h"
#import "AccountNavigationController.h"
#import "AsynchronImageLoader.h"
#import "StatCardViewController.h"
#import "CreateStatViewController.h"

#define STAT_OLD_FLAG @"old"


@implementation StatListController

static BOOL creationViewVisible = NO;
static CGFloat scrollViewScrollerY;

@synthesize myStats;
@synthesize statDetailsViewController;
@synthesize myListRequest;
@synthesize logOutRequest;
@synthesize networkIndicator;
@synthesize createStatViewController;
@synthesize deleteRequest;
@synthesize scrollView;
@synthesize pageControl;
@synthesize cards;
@synthesize deleteConfirmAlert;
@synthesize lastSelectedCard;


- (void)dealloc {
	[myStats release];
	[statDetailsViewController release];
	[myListRequest release];
	[logOutRequest release];
	[deleteRequest release];
	[networkIndicator release];
	[createStatViewController release];
	[deleteRequest release];
	[scrollView release];
	[pageControl release];
	[cards release];
	[deleteConfirmAlert release];
    [lastSelectedCard release];
	[super dealloc];
}


#pragma mark -
#pragma mark Initialization


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		NSLog(@"StatListController init");
		
        NSMutableArray *_cards = [[NSMutableArray alloc] init];
		self.cards = _cards;
        [_cards release];
		
		myStats = nil;
		statDetailsViewController = [[StatDetailsViewController alloc] initWithNibName:@"StatDetailsView" bundle:nil];
		createStatViewController  = [[CreateStatViewController alloc] initWithNibName:@"CreateStatView" bundle:nil];
        createStatViewController.closeResponder = @selector(removeCreationView);
        createStatViewController.closeObject = self;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSuccessLogin:) name:@"onSuccessLogin" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRefreshRequest:) name:@"refreshStatList" object:nil];
		
		self.title = @"Stat list";
	}
	
	return self;
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	NSLog(@"StatListController view did load");    
	[[NSNotificationCenter defaultCenter] postNotificationName:@"showLogin" object:nil];
	
	UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	UIBarButtonItem *logOutBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
	UIBarButtonItem *refreshBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(reloadStatData)];
	NSArray *items = [NSArray arrayWithObjects:space, logOutBarItem, space, refreshBarItem, space, nil];
	self.toolbarItems = items;
	[space release];
	[logOutBarItem release];
	[refreshBarItem release];
    
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onPressAddStatButton)];
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
	
	myListRequest = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
	logOutRequest = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
	
	networkIndicator = [[IndicatorViewController alloc] init];
	[self.view addSubview:networkIndicator.view];
	networkIndicator.view.center = CGPointMake(self.view.center.x, 160.0f);
	networkIndicator.view.hidden = YES;
	
	[super viewDidLoad];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


#pragma mark --
#pragma mark Custom actions

- (void)reloadStatData {
	networkIndicator.view.hidden = NO;
	Globals *globals = [Globals sharedInstance];
	NSArray *params = [[NSArray alloc] initWithObjects:globals.sessionID, @"", globals.deviceToken, nil];
	NSLog(@"ARRAY: %@", params);
	[myListRequest setMethod:@"mystat.myList" withParameters:params];
	[params release];
	XMLRPCConnectionManager *connectionManager = [XMLRPCConnectionManager sharedManager];
	[connectionManager spawnConnectionWithXMLRPCRequest:myListRequest delegate:self];
}


- (void)onSuccessLogin:(NSNotification *)notification {
	[self reloadStatData];
}


- (void)logout {
	networkIndicator.view.hidden = NO;
	Globals *global = [Globals sharedInstance];
	[logOutRequest setMethod:@"user.logout" withParameter:global.sessionID];
	XMLRPCConnectionManager *connManager = [XMLRPCConnectionManager sharedManager];
	[connManager spawnConnectionWithXMLRPCRequest:logOutRequest delegate:self];
}


+ (NSString *)elapsedTimeFromTimestamp:(NSNumber *)timestamp {
	NSDate *now = [[NSDate alloc] init];
	double secs = [now timeIntervalSince1970] - [timestamp doubleValue];
	[now release];
	
	NSString *text;
	
	if (secs < 0) {
		text = @"in the future";
		secs *= -1.0f;
	} else {
		text = @"ago";
	}
	
	if ([timestamp intValue] == 0) {
		return @"never";
	} else if (secs < 1) {
		return @"now";
	} else if (secs < 120) {
		return [NSString stringWithFormat:@"%d seconds %@", (int)secs, text];
	} else if (secs <  7200) {
		return [NSString stringWithFormat:@"%0.0f minutes %@", floor(secs / 60.0f), text];
	} else if (secs < 172800) {
		return [NSString stringWithFormat:@"%0.0f hours %@", floor(secs / 3600.0f), text];
	} else {
		return [NSString stringWithFormat:@"%0.0f days %@", floor(secs / 86400.0f), text];
	}
}


- (void)onPressAddStatButton {
    if (creationViewVisible) {
        [self removeCreationView];
    } else {
        [self openCreationView];
    }
}


- (void)onRefreshRequest:(NSNotification *)notification {
    [self reloadStatData];
	NSLog(@"Refresh.");
}


- (void)preprocessEntries {
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
	
	if (myStats && [myStats count] > 0) {
		NSDate *now = [[NSDate alloc] init];
		double now_sec = [now timeIntervalSince1970];
		[now release];
		int badge = 0;
		NSMutableArray *laterBadges = [[NSMutableArray alloc] init];
		for (id stat in myStats) {
			NSNumber *interval = [[stat valueForKey:@"config"] valueForKey:@"interval"];
			NSNumber *latest = [stat valueForKey:@"latest"];
			if ([latest doubleValue] + [interval doubleValue] <= now_sec) {
				badge++;
				[stat setValue:STAT_OLD_FLAG forKey:STAT_OLD_FLAG];
			} else {
				[laterBadges addObject:[NSNumber numberWithDouble:[latest doubleValue] + [interval doubleValue]]];
			}
		}
		
		// Order times.
		[laterBadges sortUsingComparator:^NSComparisonResult(id time1, id time2) {
			return [(NSNumber *)time1 intValue] > [(NSNumber *)time2 intValue] ? NSOrderedDescending : NSOrderedAscending;
		}];
		
		int laterBadge = badge;
		if ([laterBadges count] > 0) {
			for (id laterTime in laterBadges) {
				NSNumber *time = (NSNumber *)laterTime;
				UILocalNotification *localNotif = [[UILocalNotification alloc] init];
				NSDate *fireDate = [[NSDate alloc] initWithTimeIntervalSince1970:[time intValue]];
				localNotif.fireDate = fireDate;
				localNotif.timeZone = [NSTimeZone defaultTimeZone];
				localNotif.applicationIconBadgeNumber = ++laterBadge;
				[[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
				[fireDate release];
				[localNotif release];
			}
		}
		
		[[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
		[laterBadges release];
	}
}

- (void)rebuildCards {
	// Remove old ones.
	for (id card in self.cards) {
		StatCardViewController *cardCtrl = (StatCardViewController *)card;
		[[cardCtrl view] setHidden:YES];
		[[cardCtrl view] removeFromSuperview];
		[cardCtrl release];
		cardCtrl = nil;
	}
	
	[cards removeAllObjects];
	
	if (myStats == nil || [myStats count] == 0) {
		// @TODO Handle no stat state.
        self.pageControl.numberOfPages = 0;
        self.scrollView.contentSize = CGSizeMake(0.0f, 0.0f);
        [self openCreationView];
	}
	else {
		int idx = 0;
		for (id stat in myStats) {
			StatCardViewController *card = [[StatCardViewController alloc] initWithNibName:@"StatCardView" bundle:nil andStatData:stat];
			card.delegate = self;
			[[card view] setCenter:CGPointMake(160.0f + 320.0f * idx, 165.0f)];
			[self.scrollView addSubview:[card view]];
			[self.cards addObject:card];
			idx++;
		}
		self.pageControl.numberOfPages = [myStats count];
		self.scrollView.contentSize = CGSizeMake(320.0f * [myStats count], 330.0f);
	}
}

- (void)onPagerChanged:(id)sender {
	[self.scrollView setContentOffset:CGPointMake(self.pageControl.currentPage * 320.0f, 0.0f) animated:YES];
}

- (void)openCreationView {
    creationViewVisible = YES;
    scrollViewScrollerY = self.scrollView.center.y;
    [self.view addSubview:[createStatViewController view]];
    [[createStatViewController view] setCenter:CGPointMake(self.view.center.x, -200.0f)];
    
    [UIView animateWithDuration:0.3f animations:^{
        [[createStatViewController view] setCenter:CGPointMake(self.view.center.x, self.view.center.y + 50.0f)];  
        [self.scrollView setCenter:CGPointMake(self.view.center.x, 600.0f)];
    }];
}

- (void)removeCreationView {
    [UIView animateWithDuration:0.3f animations:^{
        [[createStatViewController view] setCenter:CGPointMake(self.view.center.x, self.view.center.y - 200.0f)];  
        [self.scrollView setCenter:CGPointMake(self.view.center.x, scrollViewScrollerY)];            
    } completion:^(BOOL finished) {
        creationViewVisible = NO;
        [[createStatViewController view] removeFromSuperview];
    }];
}


#pragma mark --
#pragma mark XMLRPC delegated methods

- (BOOL)request:(XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return NO;
}


- (void)request:(XMLRPCRequest *)request didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}


- (void)request:(XMLRPCRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"StatListController request error");
	[Globals alertNetworkError];
	networkIndicator.view.hidden = YES;
}


- (void)request:(XMLRPCRequest *)request didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}


- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response {
	networkIndicator.view.hidden = YES;
	  
	if (request == myListRequest) {
		if ([response isFault]) { // Fault response -> Exception
		} else {
			NSLog(@"List request success");
				
			if (myStats != nil) {
				[myStats release];
				myStats = nil;
			}
				
			myStats = [[NSMutableArray alloc] initWithArray:[response object]];
			
			// @TODO Check if this call is really necessary.
			[self preprocessEntries];
			
			// @TODO reload data items (cards)
			[self rebuildCards];
		}
	} else if (request == logOutRequest) {
		NSLog(@"Logout request success (or not)");
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"showLogin" object:nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"connectWithDelay" object:nil];
	} else if (request == deleteRequest) {
		if ([response isFault]) { // Fault response -> Exception
			[[NSNotificationCenter defaultCenter] postNotificationName:@"showLogin" object:nil];
		} else {
			NSLog(@"Delete request success");
			[self reloadStatData];
		}
	}
  
	NSLog(@"Response: %@", [response object]);
}


#pragma mark Scroll delegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	self.pageControl.currentPage = floor((self.scrollView.contentOffset.x + 160.0f) / 320.0f);
}


#pragma mark StatCard delegtes

- (void)statCardReceivedUpdateRequest:(StatCardViewController *)card {
	statDetailsViewController.nid = [[card statData] valueForKey:@"nid"];
	statDetailsViewController.title = [[card statData] valueForKey:@"title"];
	[self.navigationController pushViewController:statDetailsViewController animated:YES];
}

- (void)statCardReceivedDeleteRequest:(StatCardViewController *)card {
    lastSelectedCard = card;
	if (deleteConfirmAlert == nil) {
		deleteConfirmAlert = [[UIAlertView alloc] initWithTitle:@"Confirm delete action" message:@"Are you sure you want to delete this stat?" delegate:self cancelButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
	}
	[deleteConfirmAlert show];
}

#pragma mark Alert delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView == deleteConfirmAlert && buttonIndex == 0) {
        networkIndicator.view.hidden = NO;
        deleteRequest = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
        Globals *global = [Globals sharedInstance];
        [deleteRequest setMethod:@"node.delete" withParameters:[NSArray arrayWithObjects:
                                                                global.sessionID, 
                                                                [self.lastSelectedCard.statData valueForKey:@"nid"],
                                                                nil]];
        XMLRPCConnectionManager *connManager = [XMLRPCConnectionManager sharedManager];
        [connManager spawnConnectionWithXMLRPCRequest:deleteRequest delegate:self];
	}
}

@end

