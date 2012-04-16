//
//  StatListView.m
//  StatDiary
//
//  Created by Peter Arato on 4/15/12.
//  Copyright (c) 2012 itarato. All rights reserved.
//

#import "StatListView.h"

@implementation StatListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    
    CGContextSetFillColor(context, CGColorGetComponents([[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f] CGColor]));
    CGContextSetShadow(context, CGSizeMake(2, 2), 2);

    //since I need room in my rect for the shadow, make the rounded rectangle a little smaller than frame
    CGRect rrect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect) - 4.0f, CGRectGetHeight(rect)- 4.0f);
    CGFloat radius = 4.0f;
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
}


@end
