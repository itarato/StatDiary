//
//  Toggler.h
//  StatDiary
//
//  Created by Peter Arato on 4/9/13.
//  Copyright (c) 2013 itarato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Toggler : NSObject {
    NSMutableDictionary *knownBaseViewOrigins;
}

- (void)toggle:(UIView *)baseView withView:(UIView *)view withCompletion:(void(^)(void))block;

+ (Toggler *)mainToggler;

@end
