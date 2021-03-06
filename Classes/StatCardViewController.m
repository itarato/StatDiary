//
//  StatCardViewController.m
//  StatDiary
//
//  Created by Peter Arato on 1/25/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "StatCardViewController.h"
#import "EntryInfoCell.h"
#import "StatGraphHostingView.h"

@implementation StatCardViewController

@synthesize infoTable;
@synthesize titleLabel;
@synthesize statData;
@synthesize delegate;
@synthesize updateButton;
@synthesize graphHostView;

- (void)dealloc {
	[infoTable release];
	[titleLabel release];
	[statData release];
    [updateButton release];
    [graphHostView release];
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andStatData:(NSDictionary *)statDataDictionary {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.statData = statDataDictionary;
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
    [super viewDidLoad];
    
    NSDate *now = [[NSDate alloc] init];
    double now_sec = [now timeIntervalSince1970];
    [now release];
    
    NSNumber *interval = [self.statData valueForKey:@"update_interval"];
    NSNumber *latest = [self.statData valueForKey:@"latest"];
    UIImage *updateBgr;
    if ([latest doubleValue] + [interval doubleValue] <= now_sec) {
        updateBgr = [UIImage imageNamed:@"button_red.png"];
    }
    else {
        updateBgr = [UIImage imageNamed:@"button_green.png"];
    }
    UIImage *updateBgrStretched = [updateBgr stretchableImageWithLeftCapWidth:12.0f topCapHeight:12.0f];
    [self.updateButton setBackgroundImage:updateBgrStretched forState:UIControlStateNormal];
	
	self.titleLabel.text = [statData valueForKey:@"title"];
    
    // Initialize graph.
    [self.graphHostView setData:self->statData];
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

#pragma mark UITableView delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return  [(NSArray *)[self.statData valueForKey:@"info"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *InfoCellIdentifier = @"EntryInfoCell";
	
	EntryInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:InfoCellIdentifier];
	
	if (infoCell == nil) {
		NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"EntryInfoCell" owner:nil options:nil];
		for (id item in nibObjects) {
			if ([item isKindOfClass:[EntryInfoCell class]]) {
				infoCell = (EntryInfoCell *)item;
				infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
				break;
			}
		}
	}
	
	infoCell.titleLabel.text = [[(NSArray *)[self.statData valueForKey:@"info"] objectAtIndex:indexPath.row] valueForKey:@"title"];
	infoCell.valueLabel.text = [[(NSArray *)[self.statData valueForKey:@"info"] objectAtIndex:indexPath.row] valueForKey:@"value"];
	
	return infoCell;
}

#pragma mark Custom actions

- (IBAction)onPressUpdate:(id)sender {
	if ([self.delegate respondsToSelector:@selector(statCardReceivedUpdateRequest:)]) {
		[self.delegate statCardReceivedUpdateRequest:self];
	}
}

- (IBAction)onPressDelete:(id)sender {
	if ([self.delegate respondsToSelector:@selector(statCardReceivedDeleteRequest:)]) {
		[self.delegate statCardReceivedDeleteRequest:self];
	}
}

- (IBAction)onPressInfoButton:(id)sender {
    if ([self.graphHostView isHidden]) {
        [self.graphHostView setHidden:NO];
        [UIView animateWithDuration:0.3f animations:^{
            [self.graphHostView setAlpha:1.0f];
        }];
    }
    else {
        [UIView animateWithDuration:0.3f animations:^{
            [self.graphHostView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.graphHostView setHidden:YES];
        }];
    }
}

@end
