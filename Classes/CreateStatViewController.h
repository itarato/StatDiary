//
//  CreateStatViewController.h
//  StatDiary
//
//  Created by Peter Arato on 7/3/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <XMLRPC/XMLRPCConnectionDelegate.h>

@class IndicatorViewController;

@interface CreateStatViewController : UIViewController <XMLRPCConnectionDelegate> {
    IBOutlet UIButton *createButton;
    IBOutlet UITextField *titleField;
    IndicatorViewController *networkIndicator;
    SEL closeResponder;
    id closeObject;
}

@property (nonatomic, retain) UIButton *createButton;
@property (nonatomic, retain) UITextField *titleField;
@property (atomic) SEL closeResponder;
@property (nonatomic, retain) id closeObject;

- (IBAction)onPressCreateButton:(id)sender;
- (IBAction)onPressDoneKey:(id)sender;
- (IBAction)onPressCancel:(id)sender;

@end
