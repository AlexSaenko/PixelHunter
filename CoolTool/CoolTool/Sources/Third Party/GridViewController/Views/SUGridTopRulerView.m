//
//  SUGridTopRulerView.m
//  CoolTool
//
//  Created by Alex Saenko on 9/26/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridTopRulerView.h"
#import "SUConstants.h"
#import "SUDrawUtil.h"

@implementation SUGridTopRulerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{    
    CGFloat cellWidth = [self cellWidth:rect scale:self.scale.x];
    CGFloat cellDrawnWidth = cellWidth * self.scale.x;
    
//    NSArray *colorsArr = @[[UIColor redColor], [UIColor blueColor], [UIColor purpleColor], [UIColor yellowColor]];
    
    if (cellDrawnWidth > 0.0f) {
        for (NSInteger i = 0; i <= rect.size.width / cellDrawnWidth; i++) {
            CGRect rc = CGRectMake(i * cellDrawnWidth, 0.0f, cellDrawnWidth, 20.0f);
            
            CGContextRef context = UIGraphicsGetCurrentContext();
//            [self drawSeparatorLinesWithColor:[UIColor blackColor] withCellSize:cellDrawnWidth];
//            NSInteger colorIndex = i % [colorsArr count];
//            CGContextSetFillColorWithColor(context, [[colorsArr objectAtIndex:colorIndex] CGColor]);
            CGContextStrokeRect(context, rc);
            CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
            NSString *numberString = [NSString stringWithFormat:@" %.0f", i * cellWidth];
            [numberString drawInRect:rc withFont:[UIFont boldSystemFontOfSize:11.0f] lineBreakMode:NSLineBreakByWordWrapping
                           alignment:NSTextAlignmentLeft];
            
        }
    }
    
}

- (void)drawSeparatorLinesWithColor:(UIColor *)lineColor withCellSize:(CGFloat)cellSize
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSInteger startLinePoint = 0;
    NSInteger numberOfVerticalLines = ceil(self.frame.size.width / cellSize);
    
    for (NSInteger i = 0; i < numberOfVerticalLines; i++) {
        CGPoint startPoint = CGPointMake(startLinePoint, 0);
        CGPoint endPoint = CGPointMake(startLinePoint, self.frame.size.height);
        draw1PxStroke(context, startPoint, endPoint, lineColor.CGColor);
        startLinePoint = startLinePoint + cellSize;
    }

}

- (CGFloat)cellWidth:(CGRect)rect scale:(CGFloat)scale
{
    CGFloat kSUMaxCellLen = 90.0f;
    CGFloat kSUMinCellLen = 35.0f;
    NSInteger kSUSizesLen = 10;
    CGFloat arrSizes [] = {1.0f, 2.0f, 5.0f, 10.0f, 20.0f, 50.0f, 100.0f, 200.0f, 500.0f, 1000.0f};
    
    CGFloat width = rect.size.width / scale;
    CGFloat result = 0.0f;
    for (NSInteger i = 0; i < kSUSizesLen; i++) {
        CGFloat diff =  rect.size.width / (width/arrSizes[i]);
        if (diff > kSUMinCellLen && diff < kSUMaxCellLen) {
            result = arrSizes[i];
            break;
        }
    }
    
    return result;
}

@end
