//
//  MiniPanelDelegate.h
//  StatDiary
//
//  Created by Peter Arato on 4/9/13.
//  Copyright (c) 2013 itarato. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MiniPanelDelegate <NSObject>

@optional

- (void)miniPanelCallsCreate;

- (void)miniPanelCallsLogout;

@end
