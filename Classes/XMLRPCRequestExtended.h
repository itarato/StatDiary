//
//  XMLRPCRequestExtended.h
//  StatDiary
//
//  Created by Peter Arato on 9/30/11.
//  Copyright (c) 2011 Pronovix. All rights reserved.
//

//#import <XMLRPC/XMLRPCRequest.h>

@interface XMLRPCRequestExtended : XMLRPCRequest {
	SEL successCallback;
}

@property (atomic) SEL successCallback;

@end
