//
//  SUCompareToolbar.m
//  CoolTool
//
//  Created by Alex Saenko on 10/8/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUCompareToolbar.h"
#import "SUConstants.h"

@implementation SUCompareToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.slider = [[UISlider alloc] init];
        self.slider.maximumValue = 1.0f;
        self.slider.minimumValue = 0.1f;
        self.slider.value = kSUStartAlpha;
        [self addSubview:self.slider];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.slider.frame = CGRectMake(kSUCloseButtonWidth * 1.2f, 0.0f, kSUToolBarWidth - kSUCloseButtonWidth * 1.4f, kSUToolBarHeight);
}

@end
