//
//  UIButton+UIButtonExtras.m
//  StatDiary
//
//  Created by Peter Arato on 4/7/13.
//  Copyright (c) 2013 itarato. All rights reserved.
//

#import "UIButton+UIButtonExtras.h"

@implementation UIButton (UIButtonExtras)

- (void)setStretchedBackground:(NSString *)withImageNamed {
    UIImage *bgr = [UIImage imageNamed:withImageNamed];
    UIImage *bgrStretched = [bgr stretchableImageWithLeftCapWidth:12.0f topCapHeight:12.0f];
    [self setBackgroundImage:bgrStretched forState:UIControlStateNormal];
}

@end
