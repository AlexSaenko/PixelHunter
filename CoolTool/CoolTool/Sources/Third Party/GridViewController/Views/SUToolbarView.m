//
//  SUToolbarView.m
//  CoolTool
//
//  Created by Alex Saenko on 9/20/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUToolbarView.h"

static const CGFloat kSUButtonWidth = 60.0f;
static const CGFloat kSUButtonHeight = 44.0f;

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
        
        self.gridDisplayButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"off.jpg"
                                                            imageNamePressed:nil
                                                          imageNameActivated:@"ON.jpg"];
        [self addSubview:self.gridDisplayButton];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.closeButton.frame = CGRectMake(0.0f, 0.0f, kSUButtonWidth, kSUButtonHeight);
    
    self.gridDisplayButton.frame = CGRectMake(kSUButtonWidth + 20.0f, 0.0f, kSUButtonWidth, kSUButtonHeight);
}


@end
