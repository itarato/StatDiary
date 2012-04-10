//
//  StatCardDelegate.h
//  StatDiary
//
//  Created by Peter Arato on 1/29/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StatCardViewController;

@protocol StatCardDelegate <NSObject>

@optional

- (void)statCardReceivedUpdateRequest:(StatCardViewController *)card;

- (void)statCardReceivedDeleteRequest:(StatCardViewController *)card;


@end
