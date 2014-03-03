//
// Created by azu on 2014/03/03.
//


#import <Foundation/Foundation.h>
#import <DARecycledScrollView/DARecycledTileView.h>

@class ArsScaleLinear;

@interface LineChartCellView : DARecycledTileView
@property (nonatomic) NSNumber *prevY;
@property (nonatomic) NSNumber *currentY;
@property (nonatomic) NSNumber *nextY;

@property (nonatomic, weak) ArsScaleLinear *yScale;
@end