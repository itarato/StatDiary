//
//  StatCardViewController.h
//  StatDiary
//
//  Created by Peter Arato on 1/25/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatCardDelegate.h"

@class StatGraphHostingView;

@interface StatCardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UILabel *titleLabel;
	IBOutlet UITableView *infoTable;
    IBOutlet UIButton *updateButton;
    IBOutlet StatGraphHostingView *graphHostView;
    
	NSDictionary *statData;
    
	id <StatCardDelegate> delegate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andStatData:(NSDictionary *)statDataDictionary;

- (IBAction)onPressUpdate:(id)sender;
- (IBAction)onPressDelete:(id)sender;
- (IBAction)onPressInfoButton:(id)sender;

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UITableView *infoTable;
@property (nonatomic, retain) IBOutlet UIButton *updateButton;
@property (nonatomic, retain) IBOutlet StatGraphHostingView *graphHostView;
@property (nonatomic, retain) NSDictionary *statData;
@property (nonatomic, assign) id <StatCardDelegate> delegate;

@end

