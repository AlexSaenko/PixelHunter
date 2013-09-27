//
//  SUGridTopRulerView.m
//  CoolTool
//
//  Created by Alex Saenko on 9/26/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridTopRulerView.h"

static const CGFloat kSUStepSize = 40.0f;

@implementation SUGridTopRulerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
    }
    return self;
}


- (void)layoutSubviews
{
    
}

- (void)drawRect:(CGRect)rect
{
    [self drawNumbersWithStepSize:kSUStepSize];
}

- (void)drawNumbersWithStepSize:(CGFloat)stepSize
{
    CGContextRef aContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(aContext, [[UIColor greenColor] CGColor]);
    
    NSInteger numberOfVeticalLines = ceil(self.frame.size.width / stepSize);
    NSInteger startLinePoint = 0;
    for (int i = 0; i < numberOfVeticalLines; i++) {
        NSUInteger startLinePointWithScale = ceil(startLinePoint * self.scale.x);
        [[NSString stringWithFormat:@"%ld", (unsigned long)startLinePointWithScale] drawInRect:CGRectMake(startLinePoint, 0, stepSize, 20.0f) withFont:[UIFont systemFontOfSize:14] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
        startLinePoint = startLinePoint + stepSize;
    }

}

@end
