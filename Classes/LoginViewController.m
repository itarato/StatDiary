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
//@synthesize statListController;
@synthesize loginRequest;
@synthesize networkIndicator;
//@synthesize keepMeLoggedInSwitch;
//@synthesize keppMeLoggedInCell;
@synthesize userNameCell, passwordCell;


- (void)dealloc {
	[userNameField release];
	[passwordField release];
//	[statListController release];
	[loginRequest release];
	[networkIndicator release];
//	[keepMeLoggedInSwitch release];
	[super dealloc];
}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		NSLog(@"LoginViewController init.");
		loginRequest = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
		self.title = @"Sign in";
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"LoginViewController load view");
	
//	[self.keepMeLoggedInSwitch setOn:[self getKeepMeSignedIn] animated:NO];
	
	networkIndicator = [[IndicatorViewController alloc] init];
	[self.view addSubview:networkIndicator.view];
	networkIndicator.view.center = CGPointMake(self.view.center.x, 160.0f);
	networkIndicator.view.hidden = YES;
	
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


#pragma mark --
#pragma mark Custom actions


- (void) loadStatList {
	NSLog(@"Load stat list");
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"onSuccessLogin" object:nil];
	[self dismissModalViewControllerAnimated:YES];
}


//- (BOOL)getKeepMeSignedIn {
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	NSInteger value = [defaults integerForKey:KEEP_ME_LOGGED_IN];
//	return value != KEEP_ME_LOGGED_IN_NO;
//}


//- (void)setKeepMeSignedIn:(BOOL)value {
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	[defaults setInteger:(value ? KEEP_ME_LOGGED_IN_YES : KEEP_ME_LOGGED_IN_NO) forKey:KEEP_ME_LOGGED_IN];
//	if (!value) {
//		[defaults removeObjectForKey:KEEP_ME_LOGGED_IN_USERNAME];
//		[defaults removeObjectForKey:KEEP_ME_LOGGED_IN_PASSWORD];
//	}
//	
//	[defaults synchronize];
//}


//- (void)changeKeepMeLoggedInSwitch:(id)sender {
//	[self setKeepMeSignedIn:keepMeLoggedInSwitch.on];
//}


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
	if (request == loginRequest) {
		if ([response isFault]) {
			NSLog(@"Login request fail");
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login error" 
															message:@"Please, check your name and password" 
														   delegate:nil 
												  cancelButtonTitle:@"Ok" 
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


#pragma mark UITableView delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    return userNameCell;
  } else {
    return passwordCell;
  }
}


#pragma mark UIAlertView delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//  [self connect];
}


#pragma mark UITextField delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	NSLog(@"Return key pressed");
	
	networkIndicator.view.hidden = NO;
	Globals *global = [Globals sharedInstance];
	[loginRequest setMethod:@"user.login" withParameters:[NSArray arrayWithObjects:global.sessionID, userNameField.text, passwordField.text, nil]];
	XMLRPCConnectionManager *connectionManager = [XMLRPCConnectionManager sharedManager];
	[connectionManager spawnConnectionWithXMLRPCRequest:loginRequest delegate:self];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:userNameField.text forKey:LOGGED_IN_USERNAME];
	[defaults setObject:passwordField.text forKey:LOGGED_IN_PASSWORD];
	[defaults synchronize];
	
	return NO;
}



#pragma mark Static methods

+ (void)popUpLoginOn:(UIViewController *)viewController {
  LoginViewController *lvc = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
  
  [viewController presentModalViewController:lvc animated:YES];
  
  [lvc release];
}

@end
