//
//  Globals.h
//  StatDiary
//
//  Created by Peter Arato on 6/9/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Globals : NSObject {
	NSString *sessionID;
}

@property (nonatomic, retain) NSString *sessionID;

+ (Globals *) sharedInstance;

@end
