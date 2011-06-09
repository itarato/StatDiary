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
#import "MyDataNavigationController.h"
#import "Globals.h"

@implementation ApplicationViewController

@synthesize splashViewController;
@synthesize loginViewController;
@synthesize myDataNavigationController;

- (id) initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSuccessConnection:) name:@"onSuccessConnection" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSuccessAuthentication:) name:@"onSuccessAuthentication" object:nil];
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
	Globals *globals = [Globals sharedInstance];
	globals.sessionID = [result valueForKey:@"sessid"];
	uid = [result valueForKeyPath:@"user.uid"];
	
	[splashViewController.view removeFromSuperview];
	if ([uid intValue] > 0) {
		myDataNavigationController = [[MyDataNavigationController alloc] init];
		[self.view insertSubview:myDataNavigationController.view atIndex:0];
	} else {
		loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
		loginViewController.sessionID = globals.sessionID;
		[self.view insertSubview:loginViewController.view atIndex:0];
	}
}


- (void)onSuccessAuthentication:(NSNotification *)notification {
	[loginViewController.view removeFromSuperview];
	myDataNavigationController = [[MyDataNavigationController alloc] init];
	[self.view insertSubview:myDataNavigationController.view atIndex:0];
}


@end
