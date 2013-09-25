//
//  SUGridView.m
//  CoolTool
//
//  Created by Alex Saenko on 9/18/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SUGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        // Init tapGesture
        self.tapGesture = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.tapGesture];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawGridLinesWithCellSize:40.0f andLineColor:[UIColor blackColor]];
 
}

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color)
{
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)drawGridLinesWithCellSize:(CGFloat)cellSize andLineColor:(UIColor *)lineColor
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSInteger numberOfVeticalLines = ceil(self.frame.size.width / cellSize);
    NSInteger startLinePoint = 0;
    for (int i = 0; i < numberOfVeticalLines; i++) {
        CGPoint startPoint = CGPointMake(startLinePoint, 0);
        CGPoint endPoint = CGPointMake(startLinePoint, self.frame.size.height);
        draw1PxStroke(context, startPoint, endPoint, lineColor.CGColor);
        startLinePoint = startLinePoint + cellSize;
    }
    
    startLinePoint = 0;
    NSInteger numberOfHorizontalLines = ceil(self.frame.size.height / cellSize);
    
    for (int i = 0; i < numberOfHorizontalLines; i++) {
        CGPoint startPoint = CGPointMake(0, startLinePoint);
        CGPoint endPoint = CGPointMake(self.frame.size.width, startLinePoint);
        draw1PxStroke(context, startPoint, endPoint, lineColor.CGColor);
        startLinePoint = startLinePoint + cellSize;
    }
}

@end
