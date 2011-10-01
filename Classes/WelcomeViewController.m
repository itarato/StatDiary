//
//  AccountTabController.m
//  StatDiary
//
//  Created by Peter Arato on 7/2/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "IndicatorViewController.h"
#import <XMLRPC/XMLRPC.h>
#import "Globals.h"
#import "StatListController.h"
#import "XMLRPCRequestExtended.h"


@implementation WelcomeViewController


@synthesize loginViewController;
@synthesize registrationViewController;
@synthesize connectionRequest;
@synthesize networkIndicator;
@synthesize statListController;


- (void)dealloc
{
	[connectionRequest release];
	[loginViewController release];
	[networkIndicator release];
	[registrationViewController release];
	[statListController release];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		connectionRequest = [[XMLRPCRequestExtended alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
		
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRegistrationIsComplete:) name:@"registrationIsComplete" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectWithDelay) name:@"connectWithDelay" object:nil];
		
		self.title = @"StatDiary";
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
	networkIndicator = [[IndicatorViewController alloc] init];
	[self.view addSubview:networkIndicator.view];
	networkIndicator.view.center = CGPointMake(self.view.center.x, 160.0f);
	
	[self connectWithDelay];
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

- (void)onRegistrationIsComplete:(NSNotification *)notification {
//    [self.loginViewController connect];
}


#pragma mark UI actions

- (void)pressLoginButton:(id)sender {
	if ([[Globals sharedInstance] isConnected]) {
		[self openLoginView];
	} else {
		connectionRequest.successCallback = @selector(pressLoginButton:);
		[self connect];
	}
}


- (void)pressRegisterButton:(id)sender {
	if ([[Globals sharedInstance] isConnected]) {
		if (registrationViewController == nil) {
			registrationViewController = [[RegistrationViewController alloc] initWithNibName:@"RegistrationView" bundle:nil];
		}
		
		[self.navigationController pushViewController:registrationViewController animated:YES];
	} else {
		connectionRequest.successCallback = @selector(pressRegisterButton:);
		[self connect];
	}
}


#pragma mark Custom actions

- (void)connect {
	NSLog(@"Connect to Drupal");
	
	networkIndicator.view.hidden = NO;
	[connectionRequest setMethod:@"system.connect"];
	XMLRPCConnectionManager *connManager = [XMLRPCConnectionManager sharedManager];
	[connManager spawnConnectionWithXMLRPCRequest:connectionRequest delegate:self];
}


- (void)connectWithDelay {
	[self performSelector:@selector(connect) withObject:self afterDelay:0.6f];
}


- (void)openLoginView {
	if (loginViewController == nil) {
		loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
	}
	
	[self.navigationController pushViewController:loginViewController animated:YES];
}


#pragma mark XMLRPC delegates

- (BOOL)request:(XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return NO;
}


- (void)request:(XMLRPCRequest *)request didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {}


- (void)request:(XMLRPCRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"Request error in WelcomeVC");
	networkIndicator.view.hidden = YES;
	[Globals alertNetworkError];
	
	if (request == connectionRequest) {
		connectionRequest.successCallback = NULL;
	}
}

- (void)request:(XMLRPCRequest *)request didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {}

- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response {
	NSLog(@"Connect request: %@", [response object]);
	networkIndicator.view.hidden = YES;
	
	if (request == connectionRequest) {
		if ([response isFault]) {
			NSLog(@"Connection request fail");
			[Globals alertNetworkError];
		} else {
			NSLog(@"Connection request success");
			
			Globals *globals = [Globals sharedInstance];
			globals.uid = [[[response object] valueForKey:@"user"] valueForKey:@"uid"];
			globals.sessionID = [[response object] valueForKey:@"sessid"];
			
			if ([globals.uid intValue] > 0) {
			// User is already logged in.
				[self dismissModalViewControllerAnimated:YES];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatList" object:nil];
			} else if (connectionRequest.successCallback != NULL) {
			// There is a callback.
				[self performSelector:connectionRequest.successCallback withObject:nil];
			} else {
			// Fill the login form is possible.
				NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
				NSString *username = [defaults stringForKey:LOGGED_IN_USERNAME];
				NSString *password = [defaults stringForKey:LOGGED_IN_PASSWORD];
				if (username != nil && password != nil) {
					loginViewController.userNameField.text = username;
					loginViewController.passwordField.text = password;
				}
			}
		}
		connectionRequest.successCallback = NULL;
	}
}


#pragma mark UIAlertView delegates



@end
