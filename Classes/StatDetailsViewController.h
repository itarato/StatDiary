//
//  StatDetailsViewController.h
//  StatDiary
//
//  Created by Peter Arato on 6/10/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC/XMLRPCConnectionDelegate.h>

@class IndicatorViewController;

@interface StatDetailsViewController : UIViewController <XMLRPCConnectionDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource> {
	NSNumber *nid;
	IBOutlet UITextField *entryField;
	IBOutlet UIDatePicker *datePicker;
	IBOutlet UITextView *commentArea;
	IndicatorViewController *networkIndicator;
	
	UITableViewCell *entryCell;
	UITableViewCell *commentCell;
	
	UIButton *submitButton;
	
	UILabel *commentLabel;
}


@property (nonatomic, retain) NSNumber *nid;
@property (nonatomic, retain) IBOutlet UITextField *entryField;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UITextView *commentArea;
@property (nonatomic, retain) IndicatorViewController *networkIndicator;
@property (nonatomic, retain) IBOutlet UITableViewCell *entryCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *commentCell;
@property (nonatomic, retain) IBOutlet UIButton *submitButton;
@property (nonatomic, retain) IBOutlet UILabel *commentLabel;


- (IBAction)pressSubmitButton:(id)sender;
- (IBAction)onPressExitKeyOnEntryField:(id)sender;

@end
