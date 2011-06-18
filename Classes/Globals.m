//
//  Globals.m
//  StatDiary
//
//  Created by Peter Arato on 6/9/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import "Globals.h"


@implementation Globals

@synthesize sessionID;
@synthesize uid;


+ (Globals *)sharedInstance {
	static Globals *instance = nil;
	
	if (instance == nil) {
		instance = [[Globals alloc] init];
	}
	
	return instance;
}

+ (void)alertNetworkError {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network error" message:@"Try to save it later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
