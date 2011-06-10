//
//  StatListController.h
//  StatDiary
//
//  Created by Peter Arato on 6/8/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC/XMLRPCConnectionDelegate.h>


@interface StatListController : UITableViewController <XMLRPCConnectionDelegate> {
	NSMutableArray *myStats;
}

@property (nonatomic, retain) NSMutableArray *myStats;

-(void)reloadStatData;

@end
