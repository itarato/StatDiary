    //
//  Indicator.m
//  StatDiary
//
//  Created by Peter Arato on 6/12/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import "IndicatorViewController.h"


@implementation IndicatorViewController

- (id)init {
	self = [super initWithNibName:@"IndicatorView" bundle:nil];
	return self;
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


- (void)dealloc {
    [super dealloc];
}


@end
