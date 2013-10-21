//
//  SUSmallGridView.m
//  CoolTool
//
//  Created by Alex Saenko on 10/9/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUSmallGridView.h"
#import "SUDrawUtil.h"
#import "SUConstants.h"

@implementation SUSmallGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.hidden = YES;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawGridLinesWithCellSize:kSUSmallStepSize andLineColor:[UIColor colorWithWhite:0.5f alpha:0.5f]];
}

- (void)drawGridLinesWithCellSize:(CGFloat)cellSize andLineColor:(UIColor *)lineColor
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSInteger numberOfVeticalLines = ceil(self.frame.size.width / cellSize) + 1;
    NSInteger startLinePoint = 0;
    for (NSInteger i = 0; i < numberOfVeticalLines; i++) {
        CGPoint startPoint = CGPointMake(startLinePoint + self.startVerticalPoint, 0);
        CGPoint endPoint = CGPointMake(startLinePoint + self.startVerticalPoint, self.frame.size.height);
        draw1PxStroke(context, startPoint, endPoint, lineColor.CGColor);
        startLinePoint = startLinePoint + cellSize;
    }
    
    startLinePoint = 0;
    NSInteger numberOfHorizontalLines = ceil(self.frame.size.height / cellSize) + 1;
    
    for (NSInteger i = 0; i < numberOfHorizontalLines; i++) {
        CGPoint startPoint = CGPointMake(0, startLinePoint + self.startHorizontalPoint);
        CGPoint endPoint = CGPointMake(self.frame.size.width, startLinePoint + self.startHorizontalPoint);
        draw1PxStroke(context, startPoint, endPoint, lineColor.CGColor);
        startLinePoint = startLinePoint + cellSize;
    }
}

@end
