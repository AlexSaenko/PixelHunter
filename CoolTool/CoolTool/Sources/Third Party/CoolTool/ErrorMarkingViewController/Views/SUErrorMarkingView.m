//
//  SUErrorMarkingView.m
//  CoolTool
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUErrorMarkingView.h"
#import "SUConstants.h"

@interface SUErrorMarkingView ()

@property (nonatomic, strong) UIImageView *screenshotImageView;

@end

@implementation SUErrorMarkingView


- (id)initWithScreenshotImage:(UIImage *)screenshotImage
{
    self = [super init];
    if (self) {
        // Init screenshot image view
        self.screenshotImageView = [[UIImageView alloc] initWithImage:screenshotImage];
        [self addSubview:self.screenshotImageView];
        
        // Init tapGesture
        self.tapGesture = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.tapGesture];
        [self.tapGesture addTarget:self action:@selector(viewTapped)];
        
        // Init pinch gesture
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.pinchGesture];

        // Init toolbar
        self.toolbar = [[SUErrorMarkingToolbar alloc] init];
        self.toolbar.hidden = YES;
        CGSize sz = [[UIScreen mainScreen] bounds].size;
        
        CGSize toolbarSize = CGSizeMake(kSUToolBarWidth, kSUToolBarHeight / 2);
        
        self.toolbar.frame = CGRectMake(sz.width / 2 - toolbarSize.width / 2,
                                        sz.height - toolbarSize.height + kSUToolBarHeight,
                                        toolbarSize.width, toolbarSize.height);
        [self addSubview:self.toolbar];
    }
    return self;
}

- (void)layoutSubviews
{
    CGSize sz = [super bounds].size;
    
    // Layout screenshot image view
    self.screenshotImageView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
}

- (void)viewTapped
{
    CGSize sz = [super bounds].size;
    
    CGSize toolbarSize = CGSizeMake(kSUToolBarWidth, kSUToolBarHeight / 2);
    
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
