//
//  SUToolbarView.m
//  CoolTool
//
//  Created by Alex Saenko on 9/20/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUToolbarView.h"

static const CGFloat kSUCloseButtonWidth = 60.0f;
static const CGFloat kSUCloseButtonHeight = 44.0f;

@implementation SUToolbarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.userInteractionEnabled = YES;
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeButton setBackgroundColor:[UIColor yellowColor]];
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
