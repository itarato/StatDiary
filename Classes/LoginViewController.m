    //
//  LoginViewController.m
//  StatDiary
//
//  Created by Peter Arato on 6/6/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import "LoginViewController.h"
#import <XMLRPC/XMLRPC.h>
#import "Globals.h"
#import "StatListController.h"
#import "IndicatorViewController.h"


@implementation LoginViewController

@synthesize userNameField;
@synthesize passwordField;
@synthesize statListController;
@synthesize connectionRequest;
@synthesize loginRequest;
@synthesize networkIndicator;
@synthesize loginButton;
@synthesize keepMeLoggedInSwitch;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		NSLog(@"LoginViewController init.");
		connectionRequest = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
		loginRequest = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
		
		UIImage *tabBarIcon = [UIImage imageNamed:@"54-lock"];
		UITabBarItem *vTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Login" image:tabBarIcon tag:0];
		self.tabBarItem = vTabBarItem;
		[vTabBarItem release];
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"LoginViewController load view");
	
	[self.keepMeLoggedInSwitch setOn:[self getKeepMeSignedIn] animated:NO];
	
	networkIndicator = [[IndicatorViewController alloc] init];
	[self.view addSubview:networkIndicator.view];
	networkIndicator.view.center = CGPointMake(self.view.center.x, 160.0f);
	
	[self connectWithDelay];
	
	UIImage *loginButtonBgr = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *loginButtonBgrStretched = [loginButtonBgr stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[loginButton setBackgroundImage:loginButtonBgrStretched forState:UIControlStateNormal];
	
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
	[userNameField release];
	[passwordField release];
	[loginButton release];
	[statListController release];
	[connectionRequest release];
	[loginRequest release];
	[networkIndicator release];
    [keepMeLoggedInSwitch release];
    [super dealloc];
}


#pragma mark --
#pragma mark Custom actions

- (void)onPressLoginButton:(id)sender {
	NSLog(@"Login button pressed");
	
	networkIndicator.view.hidden = NO;
	Globals *global = [Globals sharedInstance];
	[loginRequest setMethod:@"user.login" withParameters:[NSArray arrayWithObjects:global.sessionID, userNameField.text, passwordField.text, nil]];
	XMLRPCConnectionManager *connectionManager = [XMLRPCConnectionManager sharedManager];
	[connectionManager spawnConnectionWithXMLRPCRequest:loginRequest delegate:self];
	
	if ([self getKeepMeSignedIn]) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:userNameField.text forKey:KEEP_ME_LOGGED_IN_USERNAME];
		[defaults setObject:passwordField.text forKey:KEEP_ME_LOGGED_IN_PASSWORD];
		[defaults synchronize];
	}
}


- (void) loadStatList {
	NSLog(@"Load stat list");
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"onSuccessLogin" object:nil];
	[self dismissModalViewControllerAnimated:YES];
}


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


- (BOOL)getKeepMeSignedIn {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger value = [defaults integerForKey:KEEP_ME_LOGGED_IN];
	return value != KEEP_ME_LOGGED_IN_NO;
}


- (void)setKeepMeSignedIn:(BOOL)value {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:(value ? KEEP_ME_LOGGED_IN_YES : KEEP_ME_LOGGED_IN_NO) forKey:KEEP_ME_LOGGED_IN];
	if (!value) {
		[defaults removeObjectForKey:KEEP_ME_LOGGED_IN_USERNAME];
		[defaults removeObjectForKey:KEEP_ME_LOGGED_IN_PASSWORD];
	}
	
	[defaults synchronize];
}


- (void)changeKeepMeLoggedInSwitch:(id)sender {
	[self setKeepMeSignedIn:keepMeLoggedInSwitch.on];
}


- (void)onPressDoneKey:(id)sender {}


#pragma mark --
#pragma mark XMLRPC delegates

- (void)request:(XMLRPCRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"LoginViewController didFailWithError");
	
	networkIndicator.view.hidden = YES;
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"App cannot reach the service. Press 'Reconnect' for another try." delegate:self cancelButtonTitle:@"Reconnect" otherButtonTitles:nil];
  [alert show];
  [alert release];
}


- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response {
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
			
			// User is already logged in.
			if ([globals.uid intValue] > 0) {
				[self loadStatList];
			} else if ([self getKeepMeSignedIn]) {
				NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
				NSString *username = [defaults stringForKey:KEEP_ME_LOGGED_IN_USERNAME];
				NSString *password = [defaults stringForKey:KEEP_ME_LOGGED_IN_PASSWORD];
				if (username != nil && password != nil) {
					userNameField.text = username;
					passwordField.text = password;
					[self onPressLoginButton:loginButton];
				}
			}
		}
	} else if (request == loginRequest) {
		if ([response isFault]) {
			NSLog(@"Login request fail");
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login error" 
															message:@"Please, check your name and password" 
														   delegate:nil 
												  cancelButtonTitle:@"Correct" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		} else {
			NSLog(@"Login request success");
			[self loadStatList];
		}
	}
	
	NSLog(@"Request: %@", [response object]);
}

- (void)request:(XMLRPCRequest *)request didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}

- (void)request:(XMLRPCRequest *)request didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}

- (BOOL)request:(XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return NO;
}


#pragma mark UIAlertView delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  [self connect];
}

@end
