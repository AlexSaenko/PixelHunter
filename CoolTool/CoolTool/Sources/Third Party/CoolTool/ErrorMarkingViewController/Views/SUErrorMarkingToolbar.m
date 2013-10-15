//
//  SUErrorMarkingToolbar.m
//  CoolTool
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUErrorMarkingToolbar.h"
#import "SUConstants.h"

@implementation SUErrorMarkingToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Init add markingview button
        self.addMarkingViewButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"gallery.png"
                                                                  imageNamePressed:nil
                                                                imageNameActivated:@"gallery.png"];
        [self addSubview:self.addMarkingViewButton];
        
        // Init send mail button
        self.sendMailButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"share.png"
                                                                      imageNamePressed:nil
                                                                    imageNameActivated:@"share.png"];
        [self addSubview:self.sendMailButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Layout grid display button
    self.addMarkingViewButton.frame = CGRectMake(kSUCloseButtonWidth + 20.0f, 0.0f, kSUCloseButtonWidth, kSUCloseButtonHeight);
    
    // Layout grid display button
    self.sendMailButton.frame = CGRectMake((kSUCloseButtonWidth + 20.0f) * 2, 0.0f, kSUCloseButtonWidth, kSUCloseButtonHeight);
}

@end
