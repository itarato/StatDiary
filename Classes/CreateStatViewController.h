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
}

@property (nonatomic, retain) UIButton *createButton;
@property (nonatomic, retain) UITextField *titleField;

- (IBAction)onPressCreateButton:(id)sender;
- (IBAction)onPressDoneKey:(id)sender;

@end
