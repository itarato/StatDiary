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

@interface StatListController : UITableViewController <XMLRPCConnectionDelegate> {
	NSMutableArray *myStats;
	StatDetailsViewController *statDetailsViewController;
}

@property (nonatomic, retain) NSMutableArray *myStats;
@property (nonatomic, retain) StatDetailsViewController *statDetailsViewController;

-(void)reloadStatData;

@end
