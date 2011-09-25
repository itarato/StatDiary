    //
//  MyDataNavigationController.m
//  StatDiary
//
//  Created by Peter Arato on 6/8/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import "MyDataNavigationController.h"
#import "StatListController.h"
#import "LoginViewController.h"


@implementation MyDataNavigationController


@synthesize statListController, welcomeViewController;


- (void)dealloc {
	[statListController release];
	[welcomeViewController release];
    [super dealloc];
}


- (id)init {
	if ((self = [super init])) {
		self.delegate = self;
	}
	
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
//	statListController = [[StatListController alloc] initWithStyle:UITableViewStyleGrouped];
//	statListController.title = @"My Stats";
	welcomeViewController = [[WelcomeViewController alloc] initWithNibName:@"WelcomeView" bundle:nil];
	welcomeViewController.title = @"Welcome";
	
//	[self pushViewController:statListController animated:NO];
	[self pushViewController:welcomeViewController animated:NO];
    
    self.navigationBar.tintColor = [UIColor darkGrayColor];
    self.toolbar.tintColor = [UIColor colorWithRed:0.9f green:0.6f blue:0.2f alpha:1.0f];
	
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	[self setToolbarHidden:(viewController != statListController) animated:YES];
}

@end
