//
//  SUCompareView.m
//  CoolTool
//
//  Created by Alex Saenko on 10/8/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUCompareView.h"
#import "SUConstants.h"

@interface SUCompareView ()

@property (nonatomic, strong) UIImageView *screenshotImageView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation SUCompareView

- (id)initWithScreenshotImage:(UIImage *)screenshotImage withMockupImage:(UIImage *)mockupImage
{
    self = [super init];
    if (self) {
        // Init screenshot image view
        self.screenshotImageView = [[UIImageView alloc] initWithImage:screenshotImage];
        [self addSubview:self.screenshotImageView];
        
        // Init mockup image view
        self.mockupImageView = [[UIImageView alloc] initWithImage:mockupImage];
        self.mockupImageView.alpha = kSUStartAlpha;
        [self addSubview:self.mockupImageView];
        
        // Init tapGesture
        self.tapGesture = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.tapGesture];
        [self.tapGesture addTarget:self action:@selector(viewTapped)];
        
        // Init toolbar
        self.toolbar = [[SUCompareToolbar alloc] init];
        self.toolbar.hidden = YES;
        [self addSubview:self.toolbar];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize sz = [[UIScreen mainScreen] bounds].size;
    
    //Layout images
    self.mockupImageView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
    
    // Layout toolbar
    CGSize toolbarSize = CGSizeMake(kSUToolBarWidth, kSUToolBarHeight);
    
    self.toolbar.frame = CGRectMake(sz.width / 2 - toolbarSize.width / 2,
                                    sz.height - toolbarSize.height + kSUToolBarHeight,
                                    toolbarSize.width, toolbarSize.height);
}

- (void)viewTapped
{
    CGSize sz = [super bounds].size;
    
    CGSize toolbarSize = CGSizeMake(kSUToolBarWidth, kSUToolBarHeight);
    
    if (self.toolbar.isHidden) {
        self.toolbar.hidden = NO;
        [UIView animateWithDuration:0.1f animations:^{
            self.toolbar.frame = CGRectMake(sz.width / 2 - toolbarSize.width / 2,
                                            sz.height - toolbarSize.height,
                                            toolbarSize.width, toolbarSize.height);
        }];
    } else {
        [UIView animateWithDuration:0.1f animations:^{
            self.toolbar.frame = CGRectMake(sz.width / 2 - toolbarSize.width / 2,
                                            sz.height - toolbarSize.height + kSUToolBarHeight,
                                            toolbarSize.width, toolbarSize.height);
        } completion:^(BOOL finished) {
            self.toolbar.hidden = YES;
        }];
        
    }
}


@end
