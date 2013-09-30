//
//  SUGridViewController.m
//  CoolTool
//
//  Created by Alex Saenko on 9/19/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridViewController.h"
#import "SUCoolTool.h"

@interface SUGridViewController () <SUGridViewControllerDelegate>

@property (nonatomic, strong) UIImage *screenshotImage;

@end

@implementation SUGridViewController

- (id)initWithScreenshotImage:(UIImage *)screenshotImage
{
	self = [super init];
	if (self) {
		self.screenshotImage = screenshotImage;
	}
	return self;
}

#pragma mark - Viewcontroller's life cycle

-(void)loadView
{
    SUGridRootView *view = [[SUGridRootView alloc] initWithScreenshotImage:self.screenshotImage];
    self.view = view;
    self.gridRootView = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.gridRootView.toolbar.closeButton addTarget:self
                                              action:@selector(tapOnCloseButton)
                                    forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.gridRootView.zoomController.pinchScale = CGPointMake(1.0f, 1.0f);
}

- (void)tapOnCloseButton
{
    [self.delegate tapOnCloseButton];
}

@end
