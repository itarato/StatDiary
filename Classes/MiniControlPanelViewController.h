//
//  MiniControlPanelViewController.h
//  StatDiary
//
//  Created by Peter Arato on 4/7/13.
//  Copyright (c) 2013 itarato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiniPanelDelegate.h"

@interface MiniControlPanelViewController : UIViewController {
    id<MiniPanelDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UIButton *logoutButton;
@property (nonatomic, retain) IBOutlet UIButton *createButton;
@property (nonatomic, assign) id<MiniPanelDelegate> delegate;

- (IBAction)onPressLogoutButton:(id)sender;
- (IBAction)onPressCreateButton:(id)sender;

@end
