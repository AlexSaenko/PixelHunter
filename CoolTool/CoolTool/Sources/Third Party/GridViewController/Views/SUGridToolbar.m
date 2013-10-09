//
//  SUGridToolbar.m
//  CoolTool
//
//  Created by Alex Saenko on 10/9/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridToolbar.h"
#import "SUConstants.h"

@implementation SUGridToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
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
    
    self.gridDisplayButton.frame = CGRectMake(kSUCloseButtonWidth + 20.0f, 0.0f, kSUCloseButtonWidth, kSUCloseButtonHeight);
}

@end
