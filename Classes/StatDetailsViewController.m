    //
//  StatDetailsViewController.m
//  StatDiary
//
//  Created by Peter Arato on 6/10/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import "StatDetailsViewController.h"
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


- (void)dealloc {
    [nid release];
    [entryField release];
    [datePicker release];
    [commentArea release];
    [networkIndicator release];
	[entryCell release];
	[commentCell release];
	[submitButton release];
	[commentLabel release];
    [super dealloc];
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
	networkIndicator.view.hidden = YES;
	
	UIImage *bgr = [UIImage imageNamed:@"button_green.png"];
	UIImage *bgrStretched = [bgr stretchableImageWithLeftCapWidth:12 topCapHeight:12];
	[submitButton setBackgroundImage:bgrStretched forState:UIControlStateNormal];
	
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

- (void)viewWillAppear:(BOOL)animated {
    if (datePicker != nil) {
        [datePicker removeFromSuperview];
        [datePicker release];
    }
    
    datePicker = [[UIDatePicker alloc] init];
    datePicker.minuteInterval = 5;
    [self.view addSubview:datePicker];
    datePicker.center = CGPointMake(self.view.center.x, self.view.frame.size.height - (datePicker.frame.size.height * 0.5f) + 44.0f);
    
	NSDate *now = [NSDate new];
	[datePicker setDate:now];
	[now release];
}

- (void)viewWillDisappear:(BOOL)animated {
    // Shut down the keyboard.
    [self.view endEditing:YES];
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
	
	NSError *error = NULL;
	NSRegularExpression *notNumber = [[NSRegularExpression alloc] initWithPattern:@"[^0-9.,\\-]" options:NSRegularExpressionCaseInsensitive error:&error];
	if ([notNumber numberOfMatchesInString:entryField.text options:0 range:NSMakeRange(0, [entryField.text length])] > 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Number field can contain only valid numeric value" delegate:nil cancelButtonTitle:@"Correct" otherButtonTitles:nil];
		[alert show];
		[alert release];
		[notNumber release];
		return;
	}
	[notNumber release];
	
	networkIndicator.view.hidden = NO;
	XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
	[request setMethod:@"mystat.submitData" withParameters:[NSArray arrayWithObjects:
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
    STAT_REQUEST_LOG_EROR(request, error, __FUNCTION__);
    
	networkIndicator.view.hidden = YES;
    
	[Globals alertNetworkError];
}


- (void)request:(XMLRPCRequest *)request didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}


- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response {
    STAT_REQUEST_LOG(request, response, __FUNCTION__);
    
	networkIndicator.view.hidden = YES;
    
	if ([response isFault]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"showLogin" object:nil];
	} 
    else {
		[entryField setText:@""];
		[commentArea setText:@""];
		[self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatList" object:response];
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
