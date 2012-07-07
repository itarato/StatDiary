//
//  Globals.h
//  StatDiary
//
//  Created by Peter Arato on 6/9/11.
//  Copyright 2011 Pronovix. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Globals : NSObject {
	NSNumber *uid;
	NSString *deviceToken;
}

@property (nonatomic, retain) NSNumber *uid;
@property (nonatomic, retain) NSString *deviceToken;

+ (Globals *)sharedInstance;
+ (void)alertNetworkError;

- (BOOL)isConnected;

@end
