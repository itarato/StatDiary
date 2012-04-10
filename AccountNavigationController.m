//
//  AccountNavigationController.m
//  StatDiary
//
//  Created by Peter Arato on 9/26/11.
//  Copyright (c) 2011 Pronovix. All rights reserved.
//

#import "AccountNavigationController.h"


@implementation AccountNavigationController


@synthesize welcomeViewController;


- (void)dealloc {
	[welcomeViewController release];
	[super dealloc];
}


- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	welcomeViewController = [[WelcomeViewController alloc] initWithNibName:@"WelcomeView" bundle:nil];
	[self pushViewController:welcomeViewController animated:NO];
	self.navigationBar.tintColor = [UIColor colorWithRed:0.0f green:0.6f blue:1.0f alpha:1.0f];
	
	UIImageView *bgrView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgr_welcome.png"]];
	[self.view insertSubview:bgrView atIndex:0];
	[bgrView release];
	
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
