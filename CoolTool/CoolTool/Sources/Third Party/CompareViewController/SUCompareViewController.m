//
//  SUCompareViewController.m
//  CoolTool
//
//  Created by Alex Saenko on 10/8/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUCompareViewController.h"
#import "SUCompareView.h"

@interface SUCompareViewController ()

@property (nonatomic, weak) SUCompareView *compareView;
@property (nonatomic, strong) UIImage *screenshotImage;
@property (nonatomic, strong) UIImage *mockupImage;

@end

@implementation SUCompareViewController

- (id)initWithScreenshotImage:(UIImage *)screenshotImage withMockupImage:(UIImage *)mockupImage
{
    self = [super init];
    if (self) {
        self.screenshotImage = screenshotImage;
        self.mockupImage = mockupImage;
    }
    return self;
}

- (void)loadView
{
    SUCompareView *view = [[SUCompareView alloc] initWithScreenshotImage:self.screenshotImage withMockupImage:self.mockupImage];
    view.contentMode = UIViewContentModeScaleAspectFit;
    self.view = view;
    self.compareView = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self.compareView.toolbar.closeButton addTarget:self
                                              action:@selector(tapOnCloseButton)
                                    forControlEvents:UIControlEventTouchUpInside];
    [self.compareView.toolbar.slider addTarget:self
                                        action:@selector(changeMockupImageAlpha:)
                              forControlEvents:UIControlEventValueChanged];
}

- (void)changeMockupImageAlpha:(UISlider *)sender
{
    self.compareView.mockupImageView.alpha = sender.value;
}

#pragma mark - Delegate

- (void)tapOnCloseButton
{
    [self.delegate tapOnCloseButton];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
