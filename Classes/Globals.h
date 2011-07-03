//
//  Globals.h
//  StatDiary
//
//  Created by Peter Arato on 6/9/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "XMLRPC/XMLRPCConnectionDelegate.h"


@interface Globals : NSObject {
	NSString *sessionID;
	NSNumber *uid;
}

@property (nonatomic, retain) NSString *sessionID;
@property (nonatomic, retain) NSNumber *uid;

+ (Globals *)sharedInstance;

+ (void)alertNetworkError;

- (void)loginUser:(NSString *)name withPassword:(NSString *)password;

@end
