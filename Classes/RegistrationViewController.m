    //
//  RegistrationViewController.m
//  StatDiary
//
//  Created by Peter Arato on 6/17/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import "RegistrationViewController.h"
#import <XMLRPC/XMLRPC.h>
#import "Globals.h"


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


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    networkIndicator = [[IndicatorViewController alloc] init];
    [self.view addSubview:networkIndicator.view];
    networkIndicator.view.center = CGPointMake(self.view.center.x, 140.0f);
    networkIndicator.view.hidden = YES;
    
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


#pragma mark --
#pragma mark XMLRPC delegates

- (BOOL)request:(XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return NO;
}


- (void)request:(XMLRPCRequest *)request didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}


- (void)request:(XMLRPCRequest *)request didFailWithError:(NSError *)error {
    [Globals alertNetworkError];
    networkIndicator.view.hidden = YES;
}


- (void)request:(XMLRPCRequest *)request didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}


- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response {
    networkIndicator.view.hidden = YES;
    if ([response isFault]) {
        NSLog(@"Register request error");
        [Globals alertNetworkError];
    } else {
        NSLog(@"Register request success");
        
        NSString *responseMessage = (NSString *)[response object];
        if ([responseMessage isEqualToString:@"ok"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"registrationIsComplete" object:response];
        } else {
            NSLog(@"Register error: %@", responseMessage);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration error" message:responseMessage delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    NSLog(@"Register response: %@", [response object]);
}


#pragma mark Custom function

//- (void)onEnterTextField:(id)sender {
//    if (((UITextField *)sender).center.y > 150.0f) {
//        [self swipeViewTo:CGPointMake(self.view.center.x, defaultCenter.y - ((UITextField *)sender).center.y + 120.0f)];
//    } else {
//        [self swipeViewTo:defaultCenter];
//    }
//}


//- (void)onPressExitOnTextField:(id)sender {
//    [self swipeViewTo:defaultCenter];
//}
        

//- (void)swipeViewTo:(CGPoint)toPoint {
//    [UIView beginAnimations:@"swipe" context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.3f];
//    self.view.center = toPoint;
//    [UIView commitAnimations];
//}


- (void)onPressRegisterButton:(id)sender {
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
    Globals *globals = [Globals sharedInstance];
    [request setMethod:@"mystat.userRegister" withParameters:[NSArray arrayWithObjects:
                                                              globals.sessionID, 
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
        


@end
