//
//  SUGridView.m
//  CoolTool
//
//  Created by Alex Saenko on 9/18/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridView.h"
#import <QuartzCore/QuartzCore.h>
#import "SUConstants.h"
#import "SUDrawUtil.h"

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
    [self drawGridLinesWithCellSize:kSUStepSize andLineColor:[UIColor blackColor]];
}

- (void)drawGridLinesWithCellSize:(CGFloat)cellSize andLineColor:(UIColor *)lineColor
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSInteger numberOfVeticalLines = ceil(self.frame.size.width / cellSize);
    NSInteger startLinePoint = 0;
    for (NSInteger i = 0; i < numberOfVeticalLines; i++) {
        CGPoint startPoint = CGPointMake(startLinePoint, 0);
        CGPoint endPoint = CGPointMake(startLinePoint, self.frame.size.height);
        draw1PxStroke(context, startPoint, endPoint, lineColor.CGColor);
        startLinePoint = startLinePoint + cellSize;
    }
    
    startLinePoint = 0;
    NSInteger numberOfHorizontalLines = ceil(self.frame.size.height / cellSize);
    
    for (NSInteger i = 0; i < numberOfHorizontalLines; i++) {
        CGPoint startPoint = CGPointMake(0, startLinePoint);
        CGPoint endPoint = CGPointMake(self.frame.size.width, startLinePoint);
        draw1PxStroke(context, startPoint, endPoint, lineColor.CGColor);
        startLinePoint = startLinePoint + cellSize;
    }
}

@end
