    //
//  StatDetailsViewController.m
//  StatDiary
//
//  Created by Peter Arato on 6/10/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import "StatDetailsViewController.h"
#import <XMLRPC/XMLRPC.h>
#import "Globals.h"
#import "IndicatorViewController.h"


@implementation StatDetailsViewController


@synthesize nid;
@synthesize entryField;
@synthesize datePicker;
@synthesize commentArea;
@synthesize networkIndicator;
@synthesize entryCell;
@synthesize commentCell;
@synthesize submitButton;
@synthesize commentLabel;


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
	networkIndicator.view.hidden = YES;
	
	UIImage *bgr = [UIImage imageNamed:@"gray_button.png"];
	UIImage *bgrStretched = [bgr stretchableImageWithLeftCapWidth:6 topCapHeight:0];
	[submitButton setBackgroundImage:bgrStretched forState:UIControlStateNormal];
	
	NSDate *now = [NSDate new];
	[datePicker setDate:now];
	[now release];
	
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
    [nid release];
    [entryField release];
    [datePicker release];
    [commentArea release];
    [networkIndicator release];
    [super dealloc];
}


#pragma mark --
#pragma mark Action handler


- (void)pressSubmitButton:(id)sender {
	if ([entryField.text length] == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Missing data entry" delegate:nil cancelButtonTitle:@"Correct" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	Globals *global = [Globals sharedInstance];
	
	NSLog(@"Session: %@", global.sessionID);
	NSLog(@"Nid: %@", nid);
	NSLog(@"Entry: %@", entryField.text);
	NSLog(@"Date: %0.2f", [datePicker.date timeIntervalSince1970]);
	NSLog(@"Comment: %@", commentArea.text);
	
	networkIndicator.view.hidden = NO;
	XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
	[request setMethod:@"mystat.submitData" withParameters:[NSArray arrayWithObjects:
															global.sessionID,
															nid,
															entryField.text,
															[NSNumber numberWithDouble:[datePicker.date timeIntervalSince1970]],
															commentArea.text,
															nil]];
	XMLRPCConnectionManager *connManager = [XMLRPCConnectionManager sharedManager];
	[connManager spawnConnectionWithXMLRPCRequest:request delegate:self];
	[request release];
}


- (void)onPressExitKeyOnEntryField:(id)sender {}

#pragma mark --
#pragma mark XMLRPC delegates

- (BOOL)request:(XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return NO;
}


- (void)request:(XMLRPCRequest *)request didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}


- (void)request:(XMLRPCRequest *)request didFailWithError:(NSError *)error {
	networkIndicator.view.hidden = YES;
	[Globals alertNetworkError];
}


- (void)request:(XMLRPCRequest *)request didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}


- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response {
	networkIndicator.view.hidden = YES;
	if ([response isFault]) {
		NSLog(@"Save request fail");
		[[NSNotificationCenter defaultCenter] postNotificationName:@"showLogin" object:nil];
	} else {
		NSLog(@"Save request success");
		
		[entryField setText:@""];
		[commentArea setText:@""];
		NSDate *now = [NSDate new];
		[datePicker setDate:now];
		[now release];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatList" object:response];
		[self.navigationController popViewControllerAnimated:YES];
	}
}


#pragma mark --
#pragma mark UITextView delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		[commentArea resignFirstResponder];
		return NO;
	}
	return YES;
}


#pragma mark -
#pragma mark UITextField delegates

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	commentLabel.alpha = 0.0f;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	if (commentArea.text.length == 0) {
		commentLabel.alpha = 1.0f;
	}
}


#pragma mark -
#pragma mark UITableView delegates


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return entryCell;
	} else {
		return commentCell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath.row == 0 ? 52 : 82;
}

@end
