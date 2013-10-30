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

        // Init error marking toolbar
        self.errorMarkingToolbar = [[SUErrorMarkingToolbar alloc] init];
        self.errorMarkingToolbar.hidden = YES;
        CGSize sz = [[UIScreen mainScreen] bounds].size;
        
        CGSize errorMarkingToolbarSize = CGSizeMake(kSUToolBarWidth, kSUToolBarHeight / 2);
        
        self.errorMarkingToolbar.frame = CGRectMake(sz.width / 2 - errorMarkingToolbarSize.width / 2,
                                        sz.height - errorMarkingToolbarSize.height + kSUToolBarHeight,
                                        errorMarkingToolbarSize.width, errorMarkingToolbarSize.height);
        [self.errorMarkingToolbar.showMarkingViewToolbarButton addTarget:self
                                                                  action:@selector(showMarkingViewToolbar)];
        [self addSubview:self.errorMarkingToolbar];
        
        // Init mark view toolbar
        self.markViewToolbar = [[SUMarkViewToolbar alloc] init];
        self.markViewToolbar.hidden = YES;
        self.markViewToolbar.frame = CGRectMake(sz.width,
                                                (sz.height - kSUMarkViewToolbarHeight) / 2,
                                                kSUMarkViewToolbarWidth, kSUMarkViewToolbarHeight);
        [self addSubview:self.markViewToolbar];
        
        // Init button actions
        [self.markViewToolbar.borderWidthSliderButton addTarget:self
                                                        action:@selector(showSlider)];
        [self.markViewToolbar.borderColorPickerButton addTarget:self
                                                         action:@selector(showColorPicker)];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    CGSize sz = [super bounds].size;
    
    // Layout screenshot image view
    self.screenshotImageView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
}

- (void)showMarkingViewToolbar
{
    CGSize sz = [super bounds].size;
    
    if (self.markViewToolbar.isHidden) {
        self.markViewToolbar.hidden = NO;
        [UIView animateWithDuration:0.1f animations:^{
            self.markViewToolbar.frame = CGRectMake(sz.width - kSUMarkViewToolbarWidth / 2,
                                                    (sz.height - kSUMarkViewToolbarHeight) / 2,
                                                    kSUMarkViewToolbarWidth, kSUMarkViewToolbarHeight);
        }];
    } else {
        [UIView animateWithDuration:0.1f animations:^{
            self.markViewToolbar.frame = CGRectMake(sz.width,
                                                    (sz.height - kSUMarkViewToolbarHeight) / 2,
                                                    kSUMarkViewToolbarWidth, kSUMarkViewToolbarHeight);
        } completion:^(BOOL finished) {
            self.markViewToolbar.hidden = YES;
            self.markViewToolbar.widthSlider.hidden = YES;
            self.markViewToolbar.markColorView.hidden = YES;
        }];
    }

}

- (void)showSlider
{
    if (!self.markViewToolbar.markColorView.hidden) {
        [UIView animateWithDuration:0.1f animations:^{
            CGRect newFrame = self.markViewToolbar.frame;
            self.markViewToolbar.frame = CGRectMake(newFrame.origin.x + kSUMarkViewToolbarWidth / 2,
                                                    newFrame.origin.y,
                                                    newFrame.size.width, newFrame.size.height);
        } completion:^(BOOL finished) {
            self.markViewToolbar.markColorView.hidden = YES;
            self.markViewToolbar.widthSlider.hidden = NO;
            [UIView animateWithDuration:0.1f animations:^{
                CGRect newFrame = self.markViewToolbar.frame;
                self.markViewToolbar.frame = CGRectMake(newFrame.origin.x - kSUMarkViewToolbarWidth / 2,
                                                        newFrame.origin.y,
                                                        newFrame.size.width, newFrame.size.height);
            }];

        }];

    } else {
        if (self.markViewToolbar.widthSlider.hidden) {
            self.markViewToolbar.widthSlider.hidden = NO;
            [UIView animateWithDuration:0.1f animations:^{
                CGRect newFrame = self.markViewToolbar.frame;
                self.markViewToolbar.frame = CGRectMake(newFrame.origin.x - kSUMarkViewToolbarWidth / 2,
                                                                         newFrame.origin.y,
                                                                         newFrame.size.width, newFrame.size.height);
            }];
            
        } else {
            [UIView animateWithDuration:0.1f animations:^{
                CGRect newFrame = self.markViewToolbar.frame;
                self.markViewToolbar.frame = CGRectMake(newFrame.origin.x + kSUMarkViewToolbarWidth / 2,
                                                                         newFrame.origin.y,
                                                                         newFrame.size.width, newFrame.size.height);
            } completion:^(BOOL finished) {
                self.markViewToolbar.widthSlider.hidden = YES;
            }];
        }
    }
}

- (void)showColorPicker
{
    if (!self.markViewToolbar.widthSlider.hidden) {
        [UIView animateWithDuration:0.1f animations:^{
            CGRect newFrame = self.markViewToolbar.frame;
            self.markViewToolbar.frame = CGRectMake(newFrame.origin.x + kSUMarkViewToolbarWidth / 2,
                                                    newFrame.origin.y,
                                                    newFrame.size.width, newFrame.size.height);
        } completion:^(BOOL finished) {
            self.markViewToolbar.widthSlider.hidden = YES;
            self.markViewToolbar.markColorView.hidden = NO;
            [UIView animateWithDuration:0.1f animations:^{
                CGRect newFrame = self.markViewToolbar.frame;
                self.markViewToolbar.frame = CGRectMake(newFrame.origin.x - kSUMarkViewToolbarWidth / 2,
                                                        newFrame.origin.y,
                                                        newFrame.size.width, newFrame.size.height);
            }];
        }];
    } else {
        if (self.markViewToolbar.markColorView.hidden) {
            self.markViewToolbar.markColorView.hidden = NO;
            [UIView animateWithDuration:0.1f animations:^{
                CGRect newFrame = self.markViewToolbar.frame;
                self.markViewToolbar.frame = CGRectMake(newFrame.origin.x - kSUMarkViewToolbarWidth / 2,
                                                        newFrame.origin.y,
                                                        newFrame.size.width, newFrame.size.height);
            }];
            
        } else {
            [UIView animateWithDuration:0.1f animations:^{
                CGRect newFrame = self.markViewToolbar.frame;
                self.markViewToolbar.frame = CGRectMake(newFrame.origin.x + kSUMarkViewToolbarWidth / 2,
                                                        newFrame.origin.y,
                                                        newFrame.size.width, newFrame.size.height);
            } completion:^(BOOL finished) {
                self.markViewToolbar.markColorView.hidden = YES;
            }];
        }
    }
}

- (void)viewTapped
{
    CGSize sz = [super bounds].size;
    
    CGSize toolbarSize = CGSizeMake(kSUToolBarWidth, kSUToolBarHeight / 2);
    
    if (self.errorMarkingToolbar.isHidden) {
        self.errorMarkingToolbar.hidden = NO;
        [UIView animateWithDuration:0.1f animations:^{
            self.errorMarkingToolbar.frame = CGRectMake(sz.width / 2 - toolbarSize.width / 2,
                                            sz.height - toolbarSize.height,
                                            toolbarSize.width, toolbarSize.height);
        }];
    } else {
        [UIView animateWithDuration:0.1f animations:^{
            self.errorMarkingToolbar.frame = CGRectMake(sz.width / 2 - toolbarSize.width / 2,
                                            sz.height - toolbarSize.height + kSUToolBarHeight,
                                            toolbarSize.width, toolbarSize.height);
            self.markViewToolbar.frame = CGRectMake(sz.width,
                                                    (sz.height - kSUMarkViewToolbarHeight) / 2,
                                                    kSUMarkViewToolbarWidth, kSUMarkViewToolbarHeight);
        } completion:^(BOOL finished) {
            self.errorMarkingToolbar.hidden = YES;
            self.markViewToolbar.hidden = YES;
            self.markViewToolbar.widthSlider.hidden = YES;
            self.markViewToolbar.markColorView.hidden = YES;
        }];
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
