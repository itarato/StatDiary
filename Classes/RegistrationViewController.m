    //
//  RegistrationViewController.m
//  StatDiary
//
//  Created by Peter Arato on 6/17/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import "RegistrationViewController.h"
#import <XMLRPC/XMLRPC.h>


@implementation RegistrationViewController

@synthesize userNameField;
@synthesize passwordField;
@synthesize passwordRetypeField;
@synthesize emailField;
@synthesize registerButton;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		UIImage *tabBarIcon = [UIImage imageNamed:@"111-user.png"];
		UITabBarItem *vTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Register" image:tabBarIcon tag:1];
		self.tabBarItem = vTabBarItem;
		[vTabBarItem release];
        // Custom initialization.
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
	UIImage *buttonBgrImage = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *buttonStretchedBrgImage = [buttonBgrImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	[registerButton setBackgroundImage:buttonStretchedBrgImage forState:UIControlStateNormal];
	
    defaultCenter = self.view.center;
    
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
    [super dealloc];
}


#pragma mark --
#pragma mark XMLRPC delegates

- (BOOL)request:(XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return NO;
}


- (void)request:(XMLRPCRequest *)request didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}


- (void)request:(XMLRPCRequest *)request didFailWithError:(NSError *)error {
}


- (void)request:(XMLRPCRequest *)request didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}


- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response {
}


#pragma mark --
#pragma mark Scroll view delegates


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
	return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}


#pragma mark Custom function

- (void)onEnterTextField:(id)sender {
    if (((UITextField *)sender).center.y > 150.0f) {
        [self swipeViewTo:CGPointMake(self.view.center.x, defaultCenter.y - ((UITextField *)sender).center.y + 120.0f)];
    } else {
        [self swipeViewTo:defaultCenter];
    }
}


- (void)onPressExitOnTextField:(id)sender {
    [self swipeViewTo:defaultCenter];
}
        

- (void)swipeViewTo:(CGPoint)toPoint {
    [UIView beginAnimations:@"swipe" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3f];
    self.view.center = toPoint;
    [UIView commitAnimations];
}
        


@end
