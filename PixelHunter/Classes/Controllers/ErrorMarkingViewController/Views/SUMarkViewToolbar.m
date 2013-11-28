//
//  SUMarkViewToolbar.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/15/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUMarkViewToolbar.h"
#import "SUConstants.h"

static CGFloat const kSUSliderWidth = 44.0f;
static CGFloat const kSUSliderHeight = 320.0f;
static CGFloat const kSUButtonIndent = 10.0f;

@implementation SUMarkViewToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.userInteractionEnabled = YES;
        
        // Init add markingview button
        self.cornerTypeButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"cornerIcon.png"
                                                                      imageNamePressed:nil
                                                                    imageNameActivated:@"cornerIcon.png"];
        [self addSubview:self.cornerTypeButton];
        
        // Init border width slider button
        self.borderWidthSliderButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"sliderIcon.png"
                                                                  imageNamePressed:nil
                                                                imageNameActivated:@"sliderIcon.png"];
        [self addSubview:self.borderWidthSliderButton];
        
        // Init width slider
        self.widthSlider = [[UISlider alloc] init];
        self.widthSlider.minimumValue = 1.0f;
        self.widthSlider.maximumValue = 4.0f;
        self.widthSlider.value = 1.0f;
        self.widthSlider.hidden = YES;
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        self.widthSlider.transform = transform;
        [self addSubview:self.widthSlider];
        
        // Init border color picker button
        self.borderColorPickerButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"colorIcon.jpg"
                                                                         imageNamePressed:nil
                                                                       imageNameActivated:@"colorIcon.jpg"];
        [self addSubview:self.borderColorPickerButton];
        
        // Init mark color view
        self.markColorView = [[SUMarkColorView alloc] init];
        [self addSubview:self.markColorView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Layout add markingview button
    self.cornerTypeButton.frame = CGRectMake(0.0f, 0.0f,
                                             kSUCloseButtonHeight, kSUCloseButtonHeight);
    
    // Layout border width slider button
    self.borderWidthSliderButton.frame = CGRectMake(0.0f, kSUCloseButtonHeight + kSUButtonIndent,
                                                    kSUCloseButtonHeight, kSUCloseButtonHeight);
    
    // Layout width slider
    self.widthSlider.frame = CGRectMake(kSUCloseButtonHeight, kSUCloseButtonHeight / 2,
                                        kSUSliderWidth, kSUSliderHeight - kSUCloseButtonHeight);
    
    // Layout border color picker button
    self.borderColorPickerButton.frame = CGRectMake(0.0f, (kSUCloseButtonHeight + kSUButtonIndent) * 2,
                                                    kSUCloseButtonHeight, kSUCloseButtonHeight);
    
    // Layout mark color view
    self.markColorView.frame = CGRectMake(kSUCloseButtonHeight, 0.0f,
                                          kSUSliderWidth, kSUSliderHeight);
}


@end
