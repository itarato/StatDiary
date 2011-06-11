    //
//  ApplicationViewController.m
//  StatDiary
//
//  Created by Peter Arato on 6/6/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import "ApplicationViewController.h"
#import "MyDataNavigationController.h"
#import "LoginViewController.h"
#import "Globals.h"

@implementation ApplicationViewController

@synthesize myDataNavigationController;
@synthesize loginViewController;

- (id) initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSuccessConnection:) name:@"onSuccessConnection" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSuccessAuthentication:) name:@"onSuccessAuthentication" object:nil];
	}
	
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
//	loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
//	myDataNavigationController = [[MyDataNavigationController alloc] initWithRootViewController:loginViewController]
//	[self.view insertSubview: atIndex:0];
//	NSLog(@"Y: %d", self.view.frame.origin.y);
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


- (void)dealloc {
	[loginViewController release];
//	[splashViewController release];
    [super dealloc];
}


- (void)onSuccessConnection:(NSNotification *)notification {
	id result = (id)[notification object];
	Globals *globals = [Globals sharedInstance];
	globals.sessionID = [result valueForKey:@"sessid"];
	uid = [result valueForKeyPath:@"user.uid"];
	
//	[splashViewController.view removeFromSuperview];
	if ([uid intValue] > 0) {
		myDataNavigationController = [[MyDataNavigationController alloc] init];
		[self.view insertSubview:myDataNavigationController.view atIndex:0];
//		[myDataNavigationController.view setFrame:self.view.bounds];
//		myDataNavigationController.navigationBar.frame = CGRectMake(0.0f, 0.0f, myDataNavigationController.navigationBar.frame.size.width, myDataNavigationController.navigationBar.frame.size.height);
	} else {
		loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
		//loginViewController.sessionID = globals.sessionID;
		[self.view insertSubview:loginViewController.view atIndex:0];
	}
}


- (void)onSuccessAuthentication:(NSNotification *)notification {
	[loginViewController.view removeFromSuperview];
	myDataNavigationController = [[MyDataNavigationController alloc] init];
	[self.view insertSubview:myDataNavigationController.view atIndex:0];
}


@end
