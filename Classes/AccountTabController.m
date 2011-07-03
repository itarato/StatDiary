//
//  AccountTabController.m
//  StatDiary
//
//  Created by Peter Arato on 7/2/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import "AccountTabController.h"
#import "LoginViewController.h"
#import "RegistrationViewController.h"


@implementation AccountTabController

@synthesize loginViewController;
@synthesize registrationViewController;

- (id)init {
    self = [super init];
    if (self) {
        loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
        registrationViewController = [[RegistrationViewController alloc] initWithNibName:@"RegistrationView" bundle:nil];
        
        NSArray *tabViews = [NSArray arrayWithObjects:loginViewController, registrationViewController, nil];
        self.viewControllers = tabViews;
        self.view.backgroundColor = [UIColor yellowColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRegistrationIsComplete:) name:@"registrationIsComplete" object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
    [self.loginViewController connect];
}

@end
