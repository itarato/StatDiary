//
//  CreateStatViewController.m
//  StatDiary
//
//  Created by Peter Arato on 7/3/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import "CreateStatViewController.h"
//#import <XMLRPC/XMLRPC.h>
#import "Globals.h"
#import "IndicatorViewController.h"


@implementation CreateStatViewController

@synthesize createButton;
@synthesize titleField;

- (void)dealloc
{
    [createButton release];
    [titleField release];
    [networkIndicator release];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.title = @"Create stats";
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
    UIImage *buttonBgr = [UIImage imageNamed:@"button_blue.png"];
    UIImage *buttonBgrStretched = [buttonBgr stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    [createButton setBackgroundImage:buttonBgrStretched forState:UIControlStateNormal];
    
    networkIndicator = [[IndicatorViewController alloc] init];
    networkIndicator.view.center = CGPointMake(self.view.center.x, 160.0f);
    networkIndicator.view.hidden = YES;
    [self.view addSubview:networkIndicator.view];
    
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
    STAT_REQUEST_LOG(request, response, __FUNCTION__);
    
	networkIndicator.view.hidden = YES;
	
	if ([response isFault]) {
		// @TODO - fix missing login popup
	} else {
		titleField.text = @"";
		[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatList" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma mark Custom actions

- (void)onPressCreateButton:(id)sender {
    if ([titleField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title error" message:@"Title field is empty" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    networkIndicator.view.hidden = NO;
    
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
    [request setMethod:@"mystat.addStat" withParameters:[NSArray arrayWithObjects: titleField.text, nil]];
    XMLRPCConnectionManager *connManager = [XMLRPCConnectionManager sharedManager];
    [connManager spawnConnectionWithXMLRPCRequest:request delegate:self];
    [request release];
}


- (void)onPressDoneKey:(id)sender {}

@end
