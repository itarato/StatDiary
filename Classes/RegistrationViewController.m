    //
//  RegistrationViewController.m
//  StatDiary
//
//  Created by Peter Arato on 6/17/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import "RegistrationViewController.h"
#import "Globals.h"
#import "Defines.h"
#import "IndicatorViewController.h"


@implementation RegistrationViewController

@synthesize userNameField;
@synthesize passwordField;
@synthesize passwordRetypeField;
@synthesize emailField;
@synthesize networkIndicator;
@synthesize userNameCell, emailCell, passwordCell, passwordRetypeCell;


- (void)dealloc {
    [userNameField release];
    [passwordField release];
    [passwordRetypeField release];
    [emailField release];
    [networkIndicator release];
	[userNameCell release];
	[emailCell release];
	[passwordCell release];
	[passwordRetypeCell release];
    [super dealloc];
}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = @"Register";
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    networkIndicator = [[IndicatorViewController alloc] init];
    [self.view addSubview:networkIndicator.view];
    networkIndicator.view.center = CGPointMake(self.view.center.x, 140.0f);
    networkIndicator.view.hidden = YES;
	
	UIBarButtonItem *regButton = [[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStyleDone target:self action:@selector(registerUser)];
	self.navigationItem.rightBarButtonItem = regButton;
	[regButton release];
	
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
#pragma mark XMLRPC delegates

- (BOOL)request:(XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return NO;
}


- (void)request:(XMLRPCRequest *)request didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}


- (void)request:(XMLRPCRequest *)request didFailWithError:(NSError *)error {
    STAT_REQUEST_LOG_EROR(request, error, __FUNCTION__);
    
    [Globals alertNetworkError];
    
    networkIndicator.view.hidden = YES;
}


- (void)request:(XMLRPCRequest *)request didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}


- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response {
    STAT_REQUEST_LOG(request, response, __FUNCTION__);
    
    networkIndicator.view.hidden = YES;
    
    if ([response isFault]) {
        [Globals alertNetworkError];
    } 
    else {
        NSString *responseMessage = (NSString *)[response object];
        if ([responseMessage isEqualToString:@"ok"]) {
			// Save reg details.
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			[defaults setObject:userNameField.text forKey:LOGGED_IN_USERNAME];
			[defaults setObject:passwordField.text forKey:LOGGED_IN_PASSWORD];
			[defaults synchronize];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatList" object:nil];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } 
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration error" message:responseMessage delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
}


#pragma mark Custom function


- (void)registerUser {
	if (![passwordField.text isEqualToString:passwordRetypeField.text]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Passwords don't match" delegate:nil cancelButtonTitle:@"Correct" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
    [request setMethod:@"mystat.userRegister" withParameters:[NSArray arrayWithObjects:
                                                              userNameField.text,
                                                              emailField.text,
                                                              passwordField.text,
                                                              nil]];
    XMLRPCConnectionManager *connManager = [XMLRPCConnectionManager sharedManager];
    [connManager spawnConnectionWithXMLRPCRequest:request delegate:self];
    [request release];
    networkIndicator.view.hidden = NO;
}


#pragma mark UITableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return userNameCell;
	} else if (indexPath.row == 1) {
		return emailCell;
	} else if (indexPath.row == 2) {
		return passwordCell;
	} else {
		return passwordRetypeCell;
	}
}
        

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 36;
}


#pragma mark UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self registerUser];
	return NO;
}


@end
