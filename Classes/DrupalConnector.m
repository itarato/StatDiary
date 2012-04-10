////
////  DrupalConnector.m
////  StatDiary
////
////  Created by Peter Arato on 2/4/12.
////  Copyright (c) 2012 Pronovix. All rights reserved.
////
//
//#import "DrupalConnector.h"
//#import <XMLRPC/XMLRPC.h>
//#import "Globals.h"
//
//@implementation DrupalConnector 
//
//@synthesize deleteRequest;
//
//- (void)dealloc {
//	[deleteRequest release];
//	[super dealloc];
//}
//
//+ (DrupalConnector *)instance {
//	static DrupalConnector *i = nil;
//	
//	if (i == nil) {
//		i = [[DrupalConnector alloc] init];
//	}
//	
//	return i;
//}
//
//#pragma mark Custom actions
//
//- (void)deleteStat:(int)nid {
//	if (deleteRequest == nil) {
//		deleteRequest = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
//	}
//    deleteRequest = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString:STATDIARY_XMLRPC_GATEWAY]];
////    Globals *global = [Globals sharedInstance];
////    [deleteRequest setMethod:@"node.delete" withParameters:[NSArray arrayWithObjects:
////                                                            global.sessionID, 
////                                                            [[myStats objectAtIndex:[indexPath indexAtPosition:0]] valueForKey:@"nid"],
////                                                            nil]];
//    XMLRPCConnectionManager *connManager = [XMLRPCConnectionManager sharedManager];
//    [connManager spawnConnectionWithXMLRPCRequest:deleteRequest delegate:self];
//}
//
//#pragma mark XMLRPCRequest delegates
//
//- (BOOL)request:(XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
//	return NO;
//}
//
//- (void)request:(XMLRPCRequest *)request didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//	
//}
//
//- (void)request:(XMLRPCRequest *)request didFailWithError:(NSError *)error {
//	if (request == deleteRequest) {
//		[[NSNotificationCenter defaultCenter] postNotificationName:__DRUPAL_CONNECTOR_REQUEST_RESULT_DELETE_ERROR object:nil];
//	}
//	else {
//		NSLog(@"Ugh, missing request.");
//	}
//}
//
//- (void)request:(XMLRPCRequest *)request didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//	
//}
//
//- (void)request:(XMLRPCRequest *)request didReceiveResponse:(XMLRPCResponse *)response {
//	if (request == deleteRequest) {
//		if (![response isFault]) {
//			[[NSNotificationCenter defaultCenter] postNotificationName:__DRUPAL_CONNECTOR_REQUEST_RESULT_DELETE_SUCCESS object:nil];
//		}
//		else {
//			// Error handling.
//		}
//	}
//	else {
//		NSLog(@"Big problem - no request found.");
//	}
//}
//
//@end
