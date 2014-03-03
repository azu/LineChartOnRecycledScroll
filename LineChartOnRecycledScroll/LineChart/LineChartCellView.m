//
// Created by azu on 2014/03/03.
//


#import "LineChartCellView.h"
#import "ArsScaleLinear.h"


@interface LineChartCellView ()
@property(nonatomic, strong) UILabel *pointLabel;
@end

@implementation LineChartCellView {

}

- (void)drawRect:(CGRect) rect {
    [super drawRect:rect];
    CGSize size = self.bounds.size;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = NO;
    [self drawContext:context size:size];
}

- (void)drawLine:(CGContextRef) context startPoint:(CGPoint) startPoint endPoint:(CGPoint) endPoint lineColor:(UIColor *) lineColor {
    CGContextSetRGBStrokeColor(context, 1.f, 0.f, 1.f, 1.f);
    CGContextSetLineWidth(context, 5.f);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
}

void NSKitCGContextAddRoundRect(CGContextRef context, CGRect rect, CGFloat radius) {
    radius = MIN(radius, rect.size.width / 2);
    radius = MIN(radius, rect.size.height / 2);
    radius = floor(radius);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
    CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius,
        radius, M_PI, M_PI / 2, 1);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius,
        rect.origin.y + rect.size.height);
    CGContextAddArc(context, rect.origin.x + rect.size.width - radius,
        rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
    CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius,
        radius, 0.0f, -M_PI / 2, 1);
    CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
    CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius,
        -M_PI / 2, M_PI, 1);
    CGContextSetFillColorWithColor(context, [UIColor purpleColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
}

// prev -> current -> next
- (void)drawContext:(CGContextRef) context size:(CGSize) size {
    CGFloat centerX = size.width / 2;
    CGPoint startPoint = CGPointMake(centerX,
        size.height - [self.yScale scale:self.currentY].floatValue);
    if (self.prevY != nil) {// first
        CGPoint prevEnd = CGPointMake(-centerX,
            size.height - [self.yScale scale:self.prevY].floatValue);
        [self drawLine:context startPoint:prevEnd endPoint:startPoint lineColor:[UIColor blackColor]];
    }
    if (self.nextY != nil) {
        CGPoint endPoint = CGPointMake(centerX + size.width, size.height -
            [self.yScale scale:self.nextY].floatValue);
        [self drawLine:context startPoint:startPoint endPoint:endPoint lineColor:[UIColor blackColor]];
    }
    if (self.currentY) {
        NSKitCGContextAddRoundRect(context, CGRectMake(startPoint.x - 5, startPoint.y - 5, 10, 10),
            10);
    }
    self.pointLabel.frame = CGRectMake(startPoint.x, startPoint.y - 30, 50, 20);
    self.pointLabel.text = [self.currentY stringValue];
}

- (UILabel *)pointLabel {
    if (_pointLabel == nil) {
        _pointLabel = [[UILabel alloc] init];
        [self addSubview:_pointLabel];
    }
    return _pointLabel;
}


@end
