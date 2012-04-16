//
//  StatCardViewController.h
//  StatDiary
//
//  Created by Peter Arato on 1/25/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatCardDelegate.h"

@interface StatCardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UILabel *titleLabel;
	IBOutlet UITableView *infoTable;
	NSDictionary *statData;
	id <StatCardDelegate> delegate;
    IBOutlet UIButton *updateButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andStatData:(NSDictionary *)statDataDictionary;

- (IBAction)onPressUpdate:(id)sender;
- (IBAction)onPressDelete:(id)sender;

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UITableView *infoTable;
@property (nonatomic, retain) NSDictionary *statData;
@property (nonatomic, assign) id <StatCardDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIButton *updateButton;

@end

//@protocol StatCardDelegate <NSObject>
//
//@optional
//
//- (void)statCardReceivedUpdateRequest:(StatCardViewController *)card;
//
//- (void)statCardReceivedDeleteRequest:(StatCardViewController *)card;
//
//
//@end
