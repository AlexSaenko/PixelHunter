//
//  SUGridToolbar.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/9/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridToolbar.h"
#import "SUConstants.h"

static CGFloat const kSUSliderMinimumValue = 0.1f;
static CGFloat const kSUSliderMaximumValue = 1.0f;

@implementation SUGridToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Init grid display button
        self.gridDisplayButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"onoff.png"
                                                                   imageNamePressed:nil
                                                                 imageNameActivated:@"onoff.png"];
        [self addSubview:self.gridDisplayButton];
        
        // Init show picker button
        self.showPickerButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"photocam.png"
                                                                   imageNamePressed:nil
                                                                 imageNameActivated:@"photocam.png"];
        [self addSubview:self.showPickerButton];
        
        // Init send mail button
        self.showMarkingViewControllerButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"arrowforward.png"
                                                                  imageNamePressed:nil
                                                                imageNameActivated:@"arrowforward.png"];
        [self addSubview:self.showMarkingViewControllerButton];
        
        // Init slider
        self.slider = [[UISlider alloc] init];
        self.slider.maximumValue = kSUSliderMaximumValue;
        self.slider.minimumValue = kSUSliderMinimumValue;
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
    self.showMarkingViewControllerButton.frame = CGRectMake((kSUCloseButtonWidth + 20.0f) * 3, 0.0f, kSUCloseButtonWidth, kSUCloseButtonHeight);
    
    // Layout slider
    self.slider.frame = CGRectMake(kSUCloseButtonWidth / 2, kSUCloseButtonHeight, kSUToolBarWidth - kSUCloseButtonWidth, kSUToolBarHeight / 2);
}

@end
