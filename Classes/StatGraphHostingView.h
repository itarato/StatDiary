//
//  StatGraphHostingView.h
//  StatDiary
//
//  Created by Peter Arato on 7/4/12.
//  Copyright (c) 2012 itarato. All rights reserved.
//

#import "CPTGraphHostingView.h"
#import "CorePlot-CocoaTouch.h"

@class CPTGraphHostingView;

@interface StatGraphHostingView : CPTGraphHostingView <CPTPlotDataSource> {
	NSDictionary *statData;
}

@property (nonatomic, retain) NSDictionary *statData;

- (void)setData:(NSDictionary *)data;

@end
