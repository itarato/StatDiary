//
//  MiniControlPanelViewController.m
//  StatDiary
//
//  Created by Peter Arato on 4/7/13.
//  Copyright (c) 2013 itarato. All rights reserved.
//

#import "MiniControlPanelViewController.h"
#import "UIButton+UIButtonExtras.h"

@interface MiniControlPanelViewController ()

@end

@implementation MiniControlPanelViewController

@synthesize logoutButton;
@synthesize createButton;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.logoutButton setStretchedBackground:@"button_red.png"];
    [self.createButton setStretchedBackground:@"button_green.png"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom actions

- (void)onPressLogoutButton:(id)sender {
    if ([self->delegate respondsToSelector:@selector(miniPanelCallsLogout)]) {
        [self->delegate miniPanelCallsLogout];
    }
}

- (void)onPressCreateButton:(id)sender {
    if ([self->delegate respondsToSelector:@selector(miniPanelCallsCreate)]) {
        [self->delegate miniPanelCallsCreate];
    }
}

@end
