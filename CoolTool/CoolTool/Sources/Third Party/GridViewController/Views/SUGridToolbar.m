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
        // Init grid display button
        self.gridDisplayButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"off.jpg"
                                                                   imageNamePressed:nil
                                                                 imageNameActivated:@"ON.jpg"];
        [self addSubview:self.gridDisplayButton];
        
        // Init show picker button
        self.showPickerButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"gallery.png"
                                                                   imageNamePressed:nil
                                                                 imageNameActivated:@"gallery.png"];
        [self addSubview:self.showPickerButton];
        
        // Init send mail button
        self.sendMailButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"share.png"
                                                                  imageNamePressed:nil
                                                                imageNameActivated:@"share.png"];
        [self addSubview:self.sendMailButton];
        
        // Init slider
        self.slider = [[UISlider alloc] init];
        self.slider.maximumValue = 1.0f;
        self.slider.minimumValue = 0.1f;
        self.slider.value = kSUStartAlpha;
        self.slider.enabled = NO;
        [self addSubview:self.slider];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Layout grid display button
    self.gridDisplayButton.frame = CGRectMake(kSUCloseButtonWidth + 20.0f, 0.0f, kSUCloseButtonWidth, kSUCloseButtonHeight);
    
    // Layout show picker button
    self.showPickerButton.frame = CGRectMake((kSUCloseButtonWidth + 20.0f) * 2, 0.0f, kSUCloseButtonWidth, kSUCloseButtonHeight);
    
    // Layout send mail button
    self.sendMailButton.frame = CGRectMake((kSUCloseButtonWidth + 20.0f) * 3, 0.0f, kSUCloseButtonWidth, kSUCloseButtonHeight);
    
    // Layout slider
    self.slider.frame = CGRectMake(kSUCloseButtonWidth / 2, kSUCloseButtonHeight, kSUToolBarWidth - kSUCloseButtonWidth, kSUToolBarHeight / 2);
}

@end
