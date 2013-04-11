    //
//  Toggler.m
//  StatDiary
//
//  Created by Peter Arato on 4/9/13.
//  Copyright (c) 2013 itarato. All rights reserved.
//

#import "Toggler.h"

Toggler *_mainToggler;

@implementation Toggler

- (id)init {
    if ((self = [super init])) {
        self->knownBaseViewOrigins = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

+ (Toggler *)mainToggler {
    if (_mainToggler == nil) {
        _mainToggler = [[Toggler alloc] init];
    }
    
    return _mainToggler;
}

- (void)toggle:(UIView *)baseView withView:(UIView *)view withCompletion:(void (^)(void))block {
    NSValue *key = [NSValue valueWithNonretainedObject:baseView];
    if (![[self->knownBaseViewOrigins allKeys] containsObject:key]) {
        [self->knownBaseViewOrigins setObject:[NSValue valueWithCGRect:baseView.frame] forKey:key];
        view.frame = CGRectMake(view.frame.origin.x,
                                baseView.frame.origin.y - view.frame.size.height,
                                view.frame.size.width,
                                view.frame.size.height);
    }
    
    NSValue *storedBaseFrame = (NSValue *)[self->knownBaseViewOrigins objectForKey:key];
    CGRect originalBaseFrame = [storedBaseFrame CGRectValue];
    
    if (CGRectEqualToRect(originalBaseFrame, baseView.frame)) {
        [view setHidden:FALSE];
        [UIView animateWithDuration:0.3f animations:^{
            view.frame = CGRectMake(baseView.frame.origin.x,
                                    baseView.frame.origin.y,
                                    view.frame.size.width,
                                    view.frame.size.height);
            baseView.center = CGPointMake(baseView.center.x, baseView.center.y + view.frame.size.height);
        } completion:^(BOOL finished) {
            if (block != nil) {
                block();
            }
        }];
    }
    else {
        [UIView animateWithDuration:0.3f animations:^{
            view.frame = CGRectMake(view.frame.origin.x,
                                    originalBaseFrame.origin.y - view.frame.size.height,
                                    view.frame.size.width,
                                    view.frame.size.height);
            baseView.frame = originalBaseFrame;
        } completion:^(BOOL finished) {
            [view setHidden:YES];
            if (block != nil) {
                block();
            }
        }];
    }
}

@end
