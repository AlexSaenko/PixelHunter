//
//  SUZGestureView.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/24/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUZGestureView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SUZGestureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.zGestureRecognizer = [[SUZGestureRecognizer alloc] init];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 2.0f;
        [self addGestureRecognizer:self.zGestureRecognizer];
        [NSTimer scheduledTimerWithTimeInterval:2.0f
                                         target:self
                                       selector:@selector(removeSelf)
                                       userInfo:nil
                                        repeats:NO];
    }
    return self;
}

- (void)removeSelf
{
    [self removeFromSuperview];
}

@end
