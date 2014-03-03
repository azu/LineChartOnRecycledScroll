//
//  ViewController.m
//  LineChartOnRecycledScroll
//
//  Created by azu on 2014/03/03.
//  Copyright (c) 2014年 azu. All rights reserved.
//

#import "ArsScale/ArsScaleLinear.h"
#import "ViewController.h"
#import "DARecycledTileView.h"
#import "LineChartCellView.h"
#import "ArsDashFunction.h"

@interface ViewController ()
@property(weak, nonatomic) IBOutlet DARecycledScrollView *plotScrollView;

@property(nonatomic, strong) NSArray *heightArray;
@property(nonatomic, strong) ArsScaleLinear *yScale;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *generatedData = [NSMutableArray array];
    for (int i = 0; i < 10000; i++) {
        [generatedData addObject:@(arc4random_uniform(100))];
    }
    self.heightArray = generatedData;
    self.plotScrollView.dataSource = self;

    CGFloat margin = 50;
    self.yScale = [[ArsScaleLinear alloc] init];
    self.yScale.domain = @[@0, ArsMax(generatedData)];
    self.yScale.range = @[@(margin), @(self.plotScrollView.frame.size.height - margin)];
    [self.plotScrollView reloadData];
}

- (NSInteger)numberOfTilesInScrollView:(DARecycledScrollView *) scrollView {
    return [self.heightArray count] + 1;
}

- (void)recycledScrollView:(DARecycledScrollView *) scrollView configureTileView:(DARecycledTileView *) tileView forIndex:(NSUInteger) index {
    LineChartCellView *chartCellView = (LineChartCellView *)tileView;
    chartCellView.prevY = nil;
    chartCellView.currentY = nil;
    chartCellView.nextY = nil;

    chartCellView.yScale = self.yScale;
    NSUInteger arraySize = [self.heightArray count];
    if (index == arraySize) {
        [chartCellView setNeedsDisplay];
        return;
    }
    if (index > 0) {
        chartCellView.prevY = self.heightArray[index - 1];
    }
    chartCellView.currentY = self.heightArray[index];
    if (arraySize != index + 1) {
        chartCellView.nextY = self.heightArray[index + 1];
    }

    [chartCellView setNeedsDisplay];
}

- (DARecycledTileView *)tileViewForRecycledScrollView:(DARecycledScrollView *) scrollView {
    LineChartCellView *chartCellView = (LineChartCellView *)[scrollView dequeueRecycledTileView];

    if (!chartCellView) {
        chartCellView = [[LineChartCellView alloc] initWithFrame:CGRectMake(0., 0., 100.,
            CGRectGetHeight(scrollView.frame))];
        chartCellView.backgroundColor = [UIColor clearColor];
        chartCellView.displayRecycledIndex = YES;
        chartCellView.layer.borderWidth = 1;
        chartCellView.layer.borderColor = [UIColor redColor].CGColor;
    }
    return chartCellView;
}

- (CGFloat)widthForTileAtIndex:(NSInteger) index1 scrollView:(DARecycledScrollView *) scrollView {
    return 100.0;
}

@end
