//
//  StatListController.m
//  StatDiary
//
//  Created by Peter Arato on 6/8/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import "StatListController.h"
#import <XMLRPC/XMLRPC.h>
#import "Globals.h"
#import "StatDetailsViewController.h"
#import "LoginViewController.h"
#import "IndicatorViewController.h"

@implementation StatListController

@synthesize myStats;
@synthesize statDetailsViewController;
@synthesize loginViewController;
@synthesize myListRequest;
@synthesize logOutRequest;
@synthesize networkIndicator;


#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
		
		NSLog(@"init table view");
		myStats = nil;
		statDetailsViewController = [[StatDetailsViewController alloc] initWithNibName:@"StatDetailsView" bundle:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSuccessLogin:) name:@"onSuccessLogin" object:nil];
        // Custom initialization.
    }
    return self;
}



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
	[self presentModalViewController:loginViewController animated:YES];
	
	[self.navigationController setToolbarHidden:NO animated:YES];
	
	UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	UIBarButtonItem *logOutBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
	UIBarButtonItem *refreshBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(reloadStatData)];
	NSArray *items = [NSArray arrayWithObjects:space, logOutBarItem, space, refreshBarItem, space, nil];
	self.toolbarItems = items;
	[space release];
	[logOutBarItem release];
	[refreshBarItem release];
	
	myListRequest = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
	logOutRequest = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
	
	networkIndicator = [[IndicatorViewController alloc] init];
	[self.view addSubview:networkIndicator.view];
	networkIndicator.view.center = CGPointMake(self.view.center.x, 160.0f);
	networkIndicator.view.hidden = YES;
	
    [super viewDidLoad];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSLog(@"DATA");
    return (myStats == nil) ? 0 : [myStats count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    // Configure the cell...
	cell.textLabel.text = [[myStats objectAtIndex:[indexPath indexAtPosition:1]] valueForKey:@"title"];
	cell.detailTextLabel.text = [NSString stringWithFormat:
								 @"%@ entry, latest %@", 
								 [[myStats objectAtIndex:[indexPath indexAtPosition:1]] valueForKey:@"count"],
								 [StatListController elapsedTimeFromTimestamp:[[myStats objectAtIndex:[indexPath indexAtPosition:1]] valueForKey:@"latest"]]];
	[cell setBackgroundColor: [UIColor colorWithRed:0.937f green:0.875f blue:0.77f alpha:1.0f]];
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	statDetailsViewController.nid = [[myStats objectAtIndex:[indexPath indexAtPosition:1]] valueForKey:@"nid"];
	statDetailsViewController.title = [[myStats objectAtIndex:[indexPath indexAtPosition:1]] valueForKey:@"title"];
	[self.navigationController pushViewController:statDetailsViewController animated:YES];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark --
#pragma mark Custom actions

- (void)reloadStatData {
	networkIndicator.view.hidden = NO;
	Globals *globals = [Globals sharedInstance];
	[myListRequest setMethod:@"mystat.myList" withParameter:globals.sessionID];
	XMLRPCConnectionManager *connectionManager = [XMLRPCConnectionManager sharedManager];
	[connectionManager spawnConnectionWithXMLRPCRequest:myListRequest delegate:self];
}


- (void)onSuccessLogin:(NSNotification *)notification {
	[self reloadStatData];
}


- (void)logout {
	networkIndicator.view.hidden = NO;
	Globals *global = [Globals sharedInstance];
	[logOutRequest setMethod:@"user.logout" withParameter:global.sessionID];
	XMLRPCConnectionManager *connManager = [XMLRPCConnectionManager sharedManager];
	[connManager spawnConnectionWithXMLRPCRequest:logOutRequest delegate:self];
}


+ (NSString *)elapsedTimeFromTimestamp:(NSNumber *)timestamp {
	NSDate *now = [[NSDate alloc] init];
	double secs = [now timeIntervalSince1970] - [timestamp doubleValue];
	
	NSString *text;
	
	if (secs < 0) {
		text = @"in the future";
		secs *= -1.0f;
	} else {
		text = @"ago";
	}
	
	if ([timestamp intValue] == 0) {
		return @"never";
	} else if (secs < 1) {
		return @"now";
	} else if (secs < 120) {
		return [NSString stringWithFormat:@"%d seconds %@", secs, text];
	} else if (secs <  7200) {
		return [NSString stringWithFormat:@"%0.0f minutes %@", floor(secs / 60.0f), text];
	} else if (secs < 172800) {
		return [NSString stringWithFormat:@"%0.0f hours %@", floor(secs / 3600.0f), text];
	} else {
		return [NSString stringWithFormat:@"%0.0f days %@", floor(secs / 86400.0f), text];
	}
}


#pragma mark --
#pragma mark XMLRPC delegated methods

- (BOOL)request:(XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return NO;
}


- (void)request:(XMLRPCRequest *)request didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}


- (void)request:(XMLRPCRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"list request error");
	networkIndicator.view.hidden = YES;
}


- (void)request:(XMLRPCRequest *)request didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}


- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response {
	networkIndicator.view.hidden = YES;
	if (request == myListRequest) {
		if ([response isFault]) {
			NSLog(@"my list error");
		} else {
			//self.navigationController.navigationBar.backItem.title = @"Log out";
			//NSLog(@"got the list: %@", [response object]);
	//		NSLog(@"Response %@", [response object]);
			myStats = [[NSMutableArray alloc] initWithArray:[response object]];
			NSLog(@"Count: %d", [myStats count]);
			[self.tableView reloadData];
		}
	} else if (request == logOutRequest) {
		if ([response isFault]) {
			NSLog(@"logout error: %@", [response object]);
		} else {
			NSLog(@"Logout success");
			NSLog(@"Logout: %@", [response object]);
			[self presentModalViewController:loginViewController animated:YES];
			[loginViewController connectWithDelay];
		}
	}

}

@end

