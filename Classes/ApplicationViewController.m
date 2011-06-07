    //
//  ApplicationViewController.m
//  StatDiary
//
//  Created by Peter Arato on 6/6/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import "ApplicationViewController.h"
#import "SplashViewController.h"
#import "LoginViewController.h"

@implementation ApplicationViewController

@synthesize splashViewController;
@synthesize loginViewController;


- (id) initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSuccessConnection:) name:@"onSuccessConnection" object:nil];
	}
	
	NSLog(@"init");
		
	return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	splashViewController = [[SplashViewController alloc] initWithNibName:@"SplashView" bundle:nil];
	[self.view insertSubview:splashViewController.view atIndex:0];
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
	[loginViewController release];
	[splashViewController release];
    [super dealloc];
}


- (void)onSuccessConnection:(NSNotification *)notification {
	id result = (id)[notification object];
	sessionID = [result valueForKey:@"sessid"];
	uid = (int)[[result valueForKey:@"user"] valueForKey:@"uid"];
	//userName = loginViewController.userNameField.text;
	//password = loginViewController.passwordField.text;
	
	[splashViewController.view removeFromSuperview];
	loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
	loginViewController.sessionID = sessionID;
	[self.view insertSubview:loginViewController.view atIndex:0];
}



@end
