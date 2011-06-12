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


@synthesize statListController;
@synthesize loginViewController;


- (id)init {
	if ((self = [super init])) {
		self.delegate = self;
	}
	
	return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	statListController = [[StatListController alloc] init];
	statListController.title = @"My Stats";
	[self pushViewController:statListController animated:NO];
	
    [super viewDidLoad];
	

//	UINavigationItem *logOutNavItem = [[UINavigationItem alloc] initWithTitle:@"Log out"];
	
//	UIBarButtonItem *logOutButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBar target:<#(id)target#> action:<#(SEL)action#>
//	self.navigationItem.leftBarButtonItem = logOutNavItem;
	//[self.navigationBar pushNavigationItem:logOutNavItem animated:YES];
	
	NSLog(@"Nav ctrl init");
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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


- (void)dealloc {
    [super dealloc];
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	[self setToolbarHidden:(viewController != statListController) animated:YES];
}

@end
