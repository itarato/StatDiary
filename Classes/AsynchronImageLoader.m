//
//  AsynchronImageLoader.m
//  StatDiary
//
//  Created by Peter Arato on 11/3/11.
//  Copyright (c) 2011 Pronovix. All rights reserved.
//

#import "AsynchronImageLoader.h"

@implementation AsynchronImageLoader

@synthesize path;
@synthesize connection;
//@synthesize data;
@synthesize cell;


- (void)dealloc {
	[path release];
	[connection release];
//	[data release];
	[cell release];
	[super dealloc];
}


- (id)initWithCell:(UITableViewCell *)theCell withPath:(NSString *)thePath {
	self = [super init];
	if (self) {
		self.cell = theCell;
		self.path = thePath;
	}
	return self;
}


- (void)loadImage {
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.path] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}


- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (data == nil) {
		data = [[NSMutableData alloc] initWithCapacity:2048];
	}
    [data appendData:incrementalData];
}


- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	UIImage *img = [[UIImage alloc] initWithData:data];
	[data release];
	self.cell.imageView.image = img;
	[self.cell setNeedsLayout];
	[img release];
}


@end
