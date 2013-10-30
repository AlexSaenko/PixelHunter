//
//  SUColorView.m
//  CoolTool
//
//  Created by Alex Saenko on 10/17/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUColorView.h"
#import "SUConstants.h"

static CGFloat const kSUColorViewSize = 20.0f;

@implementation SUColorView

- (id)initWithColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        // Init small color view
        self.smallColorView = [[UIView alloc] init];
        self.smallColorView.backgroundColor = color;
        [self addSubview:self.smallColorView];
        
        // Init color view button
        self.colorViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.colorViewButton.backgroundColor = [UIColor clearColor];
        [self addSubview:self.colorViewButton];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.smallColorView.frame = CGRectMake(self.frame.size.width / 4.0f, self.frame.size.height / 4.0f, kSUColorViewSize, kSUColorViewSize);
    self.colorViewButton.frame = kSUColorViewRect;
}

@end
