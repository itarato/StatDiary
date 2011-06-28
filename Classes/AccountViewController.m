    //
//  AccountViewController.m
//  StatDiary
//
//  Created by Peter Arato on 6/18/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import "AccountViewController.h"
#import "LoginViewController.h"
#import "RegistrationViewController.h"


@implementation AccountViewController

@synthesize loginViewController, registrationViewController, tabBar;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
	
	UITabBarItem *loginBarItem = [[UITabBarItem alloc] initWithTitle:@"Login" image:[UIImage imageNamed:@"54-lock.png"] tag:0];
	loginViewController.tabBarItem = loginBarItem;
	[loginBarItem release];
	
	[self.view insertSubview:loginViewController.view atIndex:0];
	
    [super viewDidLoad];
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


#pragma mark --
#pragma mark Custom actions

@end
