//
//  SUToolbarView.m
//  CoolTool
//
//  Created by Alex Saenko on 9/20/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUToolbarView.h"
#import "SUConstants.h"

@implementation SUToolbarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.userInteractionEnabled = YES;
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"closeIcon.jpeg"] forState:UIControlStateNormal];
        [self addSubview:self.closeButton];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.closeButton.frame = CGRectMake(0.0f, 0.0f, kSUCloseButtonWidth, kSUCloseButtonHeight);
}


@end
