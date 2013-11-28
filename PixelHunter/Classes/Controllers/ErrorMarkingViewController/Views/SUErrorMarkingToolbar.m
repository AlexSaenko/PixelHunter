//
//  SUErrorMarkingToolbar.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUErrorMarkingToolbar.h"
#import "SUConstants.h"

static CGFloat const kSUButtonIndent = 5.0f;

@implementation SUErrorMarkingToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Init add markingview button
        self.addMarkingViewButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"simplemarking.png"
                                                                  imageNamePressed:nil
                                                                imageNameActivated:@"simplemarking.png"];
        [self addSubview:self.addMarkingViewButton];
        
        // Init add text marking view button
        self.addTextMarkingViewButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"textmarking.png"
                                                                      imageNamePressed:nil
                                                                    imageNameActivated:@"textmarking.png"];
        [self addSubview:self.addTextMarkingViewButton];
        
        // Init send mail button
        self.sendMailButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"mail.png"
                                                                      imageNamePressed:nil
                                                                    imageNameActivated:@"mail.png"];
        [self addSubview:self.sendMailButton];
        
        // Init show marking view toolbar button
        self.showMarkingViewToolbarButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"settings.png"
                                                                imageNamePressed:nil
                                                              imageNameActivated:@"settings.png"];
        self.showMarkingViewToolbarButton.hidden = YES;
        self.showMarkingViewToolbarButton.enabled = NO;
        [self addSubview:self.showMarkingViewToolbarButton];
        
        // Init close button
        [self.closeButton setBackgroundImage:[UIImage imageNamed:@"arrowback.png"] forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Layout add markingview button
    self.addMarkingViewButton.frame = CGRectMake(kSUCloseButtonWidth + kSUButtonIndent, 0.0f,
                                                 kSUCloseButtonWidth, kSUCloseButtonHeight);
    // Layout add text marking view button
    self.addTextMarkingViewButton.frame = CGRectMake((kSUCloseButtonWidth + kSUButtonIndent) * 2, 0.0f,
                                                     kSUCloseButtonWidth, kSUCloseButtonHeight);
    
    // Layout send mail button
    self.sendMailButton.frame = CGRectMake((kSUCloseButtonWidth + kSUButtonIndent) * 3, 0.0f,
                                           kSUCloseButtonWidth, kSUCloseButtonHeight);
    
    // Layout show marking view toolbar button
    self.showMarkingViewToolbarButton.frame = CGRectMake((kSUCloseButtonWidth + kSUButtonIndent) * 4, 0.0f,
                                                         kSUCloseButtonWidth, kSUCloseButtonHeight);
}

@end
