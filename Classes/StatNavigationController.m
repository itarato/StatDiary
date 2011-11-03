    //
//  MyDataNavigationController.m
//  StatDiary
//
//  Created by Peter Arato on 6/8/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import "StatNavigationController.h"
#import "StatListController.h"

@implementation StatNavigationController


@synthesize statListController;
@synthesize accountNavigationController;


- (void)dealloc {
	[statListController release];
	[accountNavigationController release];
    [super dealloc];
}


- (id)init {
	if ((self = [super init])) {
		self.delegate = self;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLogin) name:@"showLogin" object:nil];
	}
	
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	accountNavigationController = [[AccountNavigationController alloc] init];
	statListController = [[StatListController alloc] initWithNibName:@"StatListView" bundle:nil];
	
	[self pushViewController:statListController animated:NO];
    
	self.navigationBar.tintColor = [UIColor darkGrayColor];
	self.toolbar.tintColor = [UIColor darkGrayColor];
	
	UIImageView *bgrView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgr_list.png"]];
	[self.view insertSubview:bgrView atIndex:0];
	[bgrView release];
	
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


#pragma mark UINavigationVC delegates

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	NSLog(@"Nav view show");
	[self setToolbarHidden:(viewController != statListController) animated:YES];
}


- (void)showLogin {
	[self presentModalViewController:accountNavigationController animated:YES];
}


@end