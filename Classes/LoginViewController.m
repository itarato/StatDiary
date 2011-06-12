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


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		connectionRequest = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
		loginRequest = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
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
	networkIndicator = [[IndicatorViewController alloc] init];
	[self.view addSubview:networkIndicator.view];
	networkIndicator.view.center = CGPointMake(self.view.center.x, 160.0f);
	
	[self connectWithDelay];
	
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
    [super dealloc];
}


#pragma mark --
#pragma mark Custom actions

- (void)onPressLoginButton:(id)sender {
	networkIndicator.view.hidden = NO;
	Globals *global = [Globals sharedInstance];
	[loginRequest setMethod:@"user.login" withParameters:[NSArray arrayWithObjects:global.sessionID, userNameField.text, passwordField.text, nil]];
	XMLRPCConnectionManager *connectionManager = [XMLRPCConnectionManager sharedManager];
	[connectionManager spawnConnectionWithXMLRPCRequest:loginRequest delegate:self];
}


- (void) loadStatList {
	NSLog(@"dismiss");
	[[NSNotificationCenter defaultCenter] postNotificationName:@"onSuccessLogin" object:nil];
	[self dismissModalViewControllerAnimated:YES];
}


- (void)connect {
	networkIndicator.view.hidden = NO;
	[connectionRequest setMethod:@"system.connect"];
	XMLRPCConnectionManager *connManager = [XMLRPCConnectionManager sharedManager];
	[connManager spawnConnectionWithXMLRPCRequest:connectionRequest delegate:self];
}


- (void)connectWithDelay {
	[self performSelector:@selector(connect) withObject:self afterDelay:0.6f];
}

#pragma mark --
#pragma mark XMLRPC delegates

- (void)request:(XMLRPCRequest *)request didFailWithError:(NSError *)error {
	networkIndicator.view.hidden = YES;
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network error" message:@"Cannot connect to StatDiary." delegate:nil cancelButtonTitle:@"Sad panda" otherButtonTitles:nil];
	[alert show];
	[alert release];
}


- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response {
	networkIndicator.view.hidden = YES;
	if (request == connectionRequest) {
		if ([response isFault]) {
			NSLog(@"Login Error: %@", [response object]);
		} else {
			NSLog(@"login success");
			NSLog(@"CONNECT %@", [response object]);
			//[[NSNotificationCenter defaultCenter] postNotificationName:@"onSuccessAuthentication" object:[response object]];
			Globals *globals = [Globals sharedInstance];
			globals.uid = [[[response object] valueForKey:@"user"] valueForKey:@"uid"];
			globals.sessionID = [[response object] valueForKey:@"sessid"];
			
			// User is already logged in.
			if ([globals.uid intValue] > 0) {
				NSLog(@"LOAD LIST");
				[self loadStatList];
			}
		}
	} else if (request == loginRequest) {
		if ([response isFault]) {
			NSLog(@"Login error: %@", [response object]);
		} else {
			NSLog(@"Login success");
			[self loadStatList];
		}
	}
}

- (void)request:(XMLRPCRequest *)request didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSLog(@"didCancelAuthenticationChallenge");
}

- (void)request:(XMLRPCRequest *)request didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSLog(@"didReceiveAuthenticationChallenge");
}

- (BOOL)request:(XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return NO;
}

@end
