//
//  AsynchronImageLoader.h
//  StatDiary
//
//  Created by Peter Arato on 11/3/11.
//  Copyright (c) 2011 Pronovix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsynchronImageLoader : NSObject {

	NSString *path;
	NSURLConnection *connection;
	NSMutableData *data;
	UITableViewCell *cell;
	
}


- (id)initWithCell:(UITableViewCell *)theCell withPath:(NSString *)thePath;
- (void)loadImage;

	
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, retain) UITableViewCell *cell;


@end
