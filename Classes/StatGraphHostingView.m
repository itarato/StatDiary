//
//  StatGraphHostingView.m
//  StatDiary
//
//  Created by Peter Arato on 7/4/12.
//  Copyright (c) 2012 itarato. All rights reserved.
//

#import "StatGraphHostingView.h"

@interface StatGraphHostingView()

- (CPTPlot *)getScatterPlotWithFrame:(CGRect)frame andMinValue:(NSDecimal)min withLine:(BOOL)withLine withFill:(BOOL)withFill;
- (CPTPlot *)getBarPlotWithFrame:(CGRect)frame;

@end

@implementation StatGraphHostingView

@synthesize statData;

- (void)setData:(NSDictionary *)data {
    self->statData = data;
    
    NSDate *now = [[NSDate alloc] init];
    double now_sec = [now timeIntervalSince1970];
    [now release];
    
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *graphTheme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:graphTheme];
    graph.frame = self.frame;
    graph.paddingBottom = -1.0f;
    graph.paddingLeft = -1.0f;
    graph.paddingRight = -1.0f;
    graph.paddingTop = -1.0f;
    [self setHostedGraph:graph];
    [graph release];
    
    // Graph data.
    NSNumber *min = [self.statData objectForKey:@"data_min"];
    NSNumber *length = [self.statData objectForKey:@"data_minmax_length"];
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.identifier = @"Plot space";
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(now_sec - 2592000) length:CPTDecimalFromInt(2678400)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat([min floatValue]) length:CPTDecimalFromFloat([length floatValue])];
    
    CPTMutableLineStyle *axisLineStyle = [[CPTMutableLineStyle alloc] init];
    axisLineStyle.lineColor = [CPTColor lightGrayColor];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *xAxis = axisSet.xAxis;
    xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    xAxis.axisLineStyle = axisLineStyle;
    
    CPTXYAxis *yAxis = axisSet.yAxis;
    yAxis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    yAxis.orthogonalCoordinateDecimal = CPTDecimalFromDouble(now_sec + 46400.0f);
    yAxis.axisLineStyle = axisLineStyle;
    yAxis.majorTickLineStyle = axisLineStyle;
    yAxis.minorTickLineStyle = axisLineStyle;
    [axisLineStyle release];
    
    NSString *dataType = (NSString *)[self->statData objectForKey:@"data_type"];
    CPTPlot *dataPlot;
    if ([dataType isEqualToString:@"spline"]) {
        dataPlot = [self getScatterPlotWithFrame:graph.frame andMinValue:CPTDecimalFromFloat([min floatValue])withLine:YES withFill:NO];
    }
    else if ([dataType isEqualToString:@"column"]) {
        dataPlot = [self getBarPlotWithFrame:graph.frame];
    }
    else if ([dataType isEqualToString:@"scatter"]) {
        dataPlot = [self getScatterPlotWithFrame:graph.frame andMinValue:CPTDecimalFromFloat([min floatValue])withLine:NO withFill:NO];
    }
    else {
        dataPlot = [self getScatterPlotWithFrame:graph.frame andMinValue:CPTDecimalFromFloat([min floatValue])withLine:YES withFill:YES];
    }
    
    [graph addPlot:dataPlot];
    [graph addPlotSpace:plotSpace];
}

- (CPTPlot *)getScatterPlotWithFrame:(CGRect)frame andMinValue:(NSDecimal)min withLine:(BOOL)withLine withFill:(BOOL)withFill {
    CPTScatterPlot *dataSourceLinePlot = [[[CPTScatterPlot alloc] initWithFrame:frame] autorelease];
    dataSourceLinePlot.identifier = @"Card plot";
    dataSourceLinePlot.dataLineStyle = nil;
    dataSourceLinePlot.dataSource = self;
    
    if (withFill) {
        CPTColor *bgr = [CPTColor colorWithComponentRed:0.5f green:0.7f blue:0.9f alpha:0.3f];
        CPTFill *fill = [(CPTFill *)[CPTFill alloc] initWithColor:bgr];
        dataSourceLinePlot.areaFill = fill;
        [fill release];
        dataSourceLinePlot.areaBaseValue = min;
    }
    
    CPTMutableLineStyle *plotLineStyle = [[CPTMutableLineStyle alloc] init];
    plotLineStyle.lineWidth = 3;
    plotLineStyle.lineColor = [CPTColor colorWithComponentRed:0.5f green:0.7f blue:0.9f alpha:(withLine ? 1.0f : 0.0f)];
    plotLineStyle.lineCap = kCGLineCapRound;
    plotLineStyle.lineJoin = kCGLineJoinRound;
    dataSourceLinePlot.dataLineStyle = plotLineStyle;
    [plotLineStyle release];
    
    CPTMutableLineStyle *dotLineStyle = [[CPTMutableLineStyle alloc] init];
    dotLineStyle.lineColor = [CPTColor colorWithComponentRed:0.2f green:0.4f blue:0.6f alpha:1.0f];
    dotLineStyle.lineWidth = 5;
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.lineStyle = dotLineStyle;
    dataSourceLinePlot.plotSymbol = plotSymbol;
    [dotLineStyle release];
    
    return dataSourceLinePlot;
}

- (CPTPlot *)getBarPlotWithFrame:(CGRect)frame {
    CPTBarPlot *barPlot = [[[CPTBarPlot alloc] initWithFrame:frame] autorelease];
    
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineColor = [CPTColor colorWithComponentRed:0.3f green:0.5f blue:0.7f alpha:1.0f];
    barPlot.lineStyle = barLineStyle;
    [barLineStyle release];
    
    barPlot.dataSource = self;
    barPlot.barCornerRadius = 2.0f;
    barPlot.barWidth = CPTDecimalFromFloat(6.0f);
    barPlot.barWidthsAreInViewCoordinates = YES;
    
    CPTColor *bgr = [CPTColor colorWithComponentRed:0.4f green:0.6f blue:0.8f alpha:1.0f];
    CPTFill *fill = [(CPTFill *)[CPTFill alloc] initWithColor:bgr];
    barPlot.fill = fill;
    [fill release];
    
    return barPlot;
}

#pragma mark CPTPlotDate delegates

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [(NSArray *)[self->statData objectForKey:@"data"] count];
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    if (fieldEnum == CPTScatterPlotFieldX) {
        return [[(NSArray *)[self->statData objectForKey:@"data"] objectAtIndex:index] objectForKey:@"x"];
    } else {
        return [[(NSArray *)[self->statData objectForKey:@"data"] objectAtIndex:index] objectForKey:@"y"];
    }
}

@end
