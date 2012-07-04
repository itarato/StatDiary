//
//  StatCardViewController.m
//  StatDiary
//
//  Created by Peter Arato on 1/25/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "StatCardViewController.h"
#import "EntryInfoCell.h"
#import "CPTGraphHostingView.h"

@implementation StatCardViewController

@synthesize infoTable;
@synthesize titleLabel;
@synthesize statData;
@synthesize delegate;
@synthesize updateButton;
@synthesize graphHostView;
//@synthesize graph;

- (void)dealloc {
	[infoTable release];
	[titleLabel release];
	[statData release];
    [updateButton release];
    [graphHostView release];
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andStatData:(NSDictionary *)statDataDictionary {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.statData = statDataDictionary;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDate *now = [[NSDate alloc] init];
    double now_sec = [now timeIntervalSince1970];
    
    NSNumber *interval = [[self.statData valueForKey:@"config"] valueForKey:@"interval"];
    NSNumber *latest = [self.statData valueForKey:@"latest"];
    UIImage *updateBgr;
    if ([latest doubleValue] + [interval doubleValue] <= now_sec) {
        updateBgr = [UIImage imageNamed:@"button_red.png"];
    }
    else {
        updateBgr = [UIImage imageNamed:@"button_green.png"];
    }
    UIImage *updateBgrStretched = [updateBgr stretchableImageWithLeftCapWidth:12.0f topCapHeight:12.0f];
    [self.updateButton setBackgroundImage:updateBgrStretched forState:UIControlStateNormal];
	
	self.titleLabel.text = [statData valueForKey:@"title"];
    
    // Initialize graph.
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *graphTheme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:graphTheme];
    graph.frame = self->graphHostView.frame;
    graph.paddingBottom = -1.0f;
    graph.paddingLeft = -1.0f;
    graph.paddingRight = -1.0f;
    graph.paddingTop = -1.0f;
    [self.graphHostView setHostedGraph: graph];
    [graph release];
    
    // Graph data.
    NSNumber *min = [self.statData objectForKey:@"data_min"];
    NSNumber *length = [self.statData objectForKey:@"data_minmax_length"];
    
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] initWithFrame:graph.bounds];
    dataSourceLinePlot.identifier = @"Card plot";
    dataSourceLinePlot.dataLineStyle = nil;
    dataSourceLinePlot.dataSource = self;

    CPTColor *bgr = [CPTColor colorWithComponentRed:0.5f green:0.7f blue:0.9f alpha:0.3f];
    CPTFill *fill = [(CPTFill *)[CPTFill alloc] initWithColor:bgr];
    dataSourceLinePlot.areaFill = fill;
    dataSourceLinePlot.areaBaseValue = CPTDecimalFromFloat([min floatValue]);
    
    CPTMutableLineStyle *plotLineStyle = [[CPTMutableLineStyle alloc] init];
    plotLineStyle.lineWidth = 3;
    plotLineStyle.lineColor = [CPTColor colorWithComponentRed:0.5f green:0.7f blue:0.9f alpha:1.0f];
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
    yAxis.orthogonalCoordinateDecimal = CPTDecimalFromDouble(now_sec + 86400.0f);
    yAxis.axisLineStyle = axisLineStyle;
    yAxis.majorTickLineStyle = axisLineStyle;
    yAxis.minorTickLineStyle = axisLineStyle;
    [axisLineStyle release];
    
    [graph addPlot:dataSourceLinePlot];
    [graph addPlotSpace:plotSpace];
    [dataSourceLinePlot release];
    
    [now release];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableView delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return  [(NSArray *)[self.statData valueForKey:@"info"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *InfoCellIdentifier = @"EntryInfoCell";
	
	EntryInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:InfoCellIdentifier];
	
	if (infoCell == nil) {
		NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"EntryInfoCell" owner:nil options:nil];
		for (id item in nibObjects) {
			if ([item isKindOfClass:[EntryInfoCell class]]) {
				infoCell = (EntryInfoCell *)item;
				infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
				break;
			}
		}
	}
	
	infoCell.titleLabel.text = [[(NSArray *)[self.statData valueForKey:@"info"] objectAtIndex:indexPath.row] valueForKey:@"title"];
	infoCell.valueLabel.text = [[(NSArray *)[self.statData valueForKey:@"info"] objectAtIndex:indexPath.row] valueForKey:@"value"];
	
	return infoCell;
}

#pragma mark Custom actions

- (IBAction)onPressUpdate:(id)sender {
	if ([self.delegate respondsToSelector:@selector(statCardReceivedUpdateRequest:)]) {
		[self.delegate statCardReceivedUpdateRequest:self];
	}
}

- (IBAction)onPressDelete:(id)sender {
	if ([self.delegate respondsToSelector:@selector(statCardReceivedDeleteRequest:)]) {
		[self.delegate statCardReceivedDeleteRequest:self];
	}
}

- (IBAction)onPressInfoButton:(id)sender {
    if ([self.graphHostView isHidden]) {
        [self.graphHostView setHidden:NO];
        [UIView animateWithDuration:0.3f animations:^{
            [self.graphHostView setAlpha:1.0f];
        }];
    }
    else {
        [UIView animateWithDuration:0.3f animations:^{
            [self.graphHostView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.graphHostView setHidden:YES];
        }];
    }
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
