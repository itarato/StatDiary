//
//  StatDetailsViewController.h
//  StatDiary
//
//  Created by Peter Arato on 6/10/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMLRPC/XMLRPCConnectionDelegate.h>


@interface StatDetailsViewController : UIViewController <XMLRPCConnectionDelegate, UITextViewDelegate> {
	NSNumber *nid;
	IBOutlet UITextField *entryField;
	IBOutlet UIDatePicker *datePicker;
	IBOutlet UITextView *commentArea;
}

@property (nonatomic, retain) NSNumber *nid;
@property (nonatomic, retain) IBOutlet UITextField *entryField;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UITextView *commentArea;

- (IBAction)pressSubmitButton:(id)sender;
- (IBAction)onPressExitKeyOnEntryField:(id)sender;

@end
