//
//  SUColorView.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/17/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUColorView.h"
#import "SUConstants.h"

static CGFloat const kSUColorViewSize = 20.0f;

@interface SUColorView ()



@end

@implementation SUColorView

- (id)initWithColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        // Init color
        self.color = color;
        
        // Init color view button
        self.colorViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.colorViewButton.backgroundColor = [UIColor clearColor];
        [self addSubview:self.colorViewButton];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGPoint center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        CGContextBeginPath(ctx);
    
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, center.x, center.y, 10.0, 0, 2*M_PI, 0);
    CGContextClosePath(ctx);
    CGContextSetFillColorWithColor(ctx, [self.color CGColor]);
    CGContextSetStrokeColorWithColor(ctx, [self.color CGColor]);
    CGContextDrawPath(ctx, kCGPathFillStroke);

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.colorViewButton.frame = kSUColorViewRect;
}

@end
