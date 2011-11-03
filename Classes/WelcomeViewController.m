//
//  AccountTabController.m
//  StatDiary
//
//  Created by Peter Arato on 7/2/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import "WelcomeViewController.h"
#import "RegistrationViewController.h"
#import "IndicatorViewController.h"
#import <XMLRPC/XMLRPC.h>
#import "Globals.h"
#import "StatListController.h"
#import "XMLRPCRequestExtended.h"


@interface WelcomeViewController () 

- (void)sendDeviceInfo;

@end


@implementation WelcomeViewController


@synthesize registrationViewController;
@synthesize connectionRequest;
@synthesize infoRequest;
@synthesize networkIndicator;
@synthesize statListController;
@synthesize usernameCell;
@synthesize passwordCell;
@synthesize loginRequest;
@synthesize userNameField;
@synthesize passwordField;
@synthesize loginButton;


- (void)dealloc
{
	[connectionRequest release];
	[networkIndicator release];
	[registrationViewController release];
	[statListController release];
	[infoRequest release];
	[usernameCell release];
	[passwordCell release];
	[loginRequest release];
	[userNameField release];
	[passwordField release];
	[loginButton release];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		connectionRequest = [[XMLRPCRequestExtended alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
		infoRequest       = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
		loginRequest      = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
		
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
	
	UIImage *buttonBgr = [UIImage imageNamed:@"gray_button.png"];
	UIImage *buttonBgrStretched = [buttonBgr stretchableImageWithLeftCapWidth:6 topCapHeight:0];
	[loginButton setBackgroundImage:buttonBgrStretched forState:UIControlStateNormal];
	
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
		[self login];
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


- (void) loadStatList {
	NSLog(@"Load stat list");
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"onSuccessLogin" object:nil];
	[self dismissModalViewControllerAnimated:YES];
}


- (void)login {
	networkIndicator.view.hidden = NO;
	Globals *global = [Globals sharedInstance];
	[loginRequest setMethod:@"user.login" withParameters:[NSArray arrayWithObjects:global.sessionID, userNameField.text, passwordField.text, nil]];
	XMLRPCConnectionManager *connectionManager = [XMLRPCConnectionManager sharedManager];
	[connectionManager spawnConnectionWithXMLRPCRequest:loginRequest delegate:self];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:userNameField.text forKey:LOGGED_IN_USERNAME];
	[defaults setObject:passwordField.text forKey:LOGGED_IN_PASSWORD];
	[defaults synchronize];
}


- (void)onPressDoneKey:(id)sender {}


// Send device info to the server.
- (void)sendDeviceInfo {
	if ([[Globals sharedInstance] deviceToken] != nil) {
		NSArray *params = [[NSArray alloc] initWithObjects:
						   [[Globals sharedInstance] sessionID], 
						   [[Globals sharedInstance] deviceToken],
						   [[UIDevice currentDevice] uniqueIdentifier],
						   @"com.itarato.StatDiary",
						   @"1.1",
						   nil];
		[infoRequest setMethod:@"mystatapp.deviceInfo" withParameters:params];
		XMLRPCConnectionManager *connManager = [XMLRPCConnectionManager sharedManager];
		[connManager spawnConnectionWithXMLRPCRequest:infoRequest delegate:self];
		[params release];
	}
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
	} else if (request == loginRequest) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"App cannot reach the service. Press 'Reconnect' for another try." delegate:self cancelButtonTitle:@"Reconnect" otherButtonTitles:nil];
		[alert show];
		[alert release];
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
			
			[self sendDeviceInfo];
			
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
					self.userNameField.text = username;
					self.passwordField.text = password;
				}
			}
		}
		connectionRequest.successCallback = NULL;
	} else if (request == infoRequest) {
		// Do nothing - do not care.
	} else if (request == loginRequest) {
		if ([response isFault]) {
			NSLog(@"Login request fail");
			NSNumber *faultCode = [[response object] valueForKey:@"faultCode"];
			if ([faultCode intValue] == 406) {
				// Already logged in.
				NSLog(@"Already logged in");
				[self.navigationController dismissModalViewControllerAnimated:YES];
			} else {
				// Wrong account details.
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login error" 
																message:@"Please, check your name and password" 
															   delegate:nil 
													  cancelButtonTitle:@"Ok" 
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
		} else {
			NSLog(@"Login request success");
			[self loadStatList];
		}
	}
}


#pragma mark UITableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return usernameCell;
	} else {
		return passwordCell;
	}	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 36;
}


@end
