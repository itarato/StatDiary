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

+ (Globals *)sharedInstance {
	static Globals *instance = nil;
	
	if (instance == nil) {
		instance = [[Globals alloc] init];
	}
	
	return instance;
}

@end
