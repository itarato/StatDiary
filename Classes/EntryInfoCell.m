//
//  EntryInfoCell.m
//  StatDiary
//
//  Created by Peter Arato on 1/26/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "EntryInfoCell.h"

@implementation EntryInfoCell

@synthesize titleLabel;
@synthesize valueLabel;

- (void)dealloc {
	[titleLabel release];
	[valueLabel release];
	[super dealloc];
}

@end
