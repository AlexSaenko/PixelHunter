//
//  SUGridViewController.m
//  CoolTool
//
//  Created by Alex Saenko on 9/19/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridViewController.h"
#import "SUCoolTool.h"
#import "SUConstants.h"

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

- (void)loadView
{
    CGSize sz = [[UIScreen mainScreen] applicationFrame].size;
    SUGridRootView *view = [[SUGridRootView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, sz.width, sz.height) withScreenshotImage:self.screenshotImage];
    view.contentMode = UIViewContentModeScaleAspectFit;
    self.view = view;
    self.gridRootView = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    [self.gridRootView.toolbar.closeButton addTarget:self
                                              action:@selector(tapOnCloseButton)
                                    forControlEvents:UIControlEventTouchUpInside];
    
    self.gridRootView.gridUnderLayerView.scrollView.delegate = self;
    self.gridRootView.gridUnderLayerView.scrollView.contentSize = self.gridRootView.gridUnderLayerView.containerView.frame.size;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.gridRootView.gridUnderLayerView.scrollView.minimumZoomScale = self.gridRootView.gridUnderLayerView.scrollView.frame.size.width / self.gridRootView.gridUnderLayerView.containerView.frame.size.width;
    self.gridRootView.gridUnderLayerView.scrollView.maximumZoomScale = kSUMaximumZoomScale;
    [self.gridRootView.gridUnderLayerView.scrollView setZoomScale:self.gridRootView.gridUnderLayerView.scrollView.minimumZoomScale];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.gridRootView.gridUnderLayerView.containerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeRulerPositions];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.gridRootView.gridUnderLayerView.containerView.frame = [self centeredFrameForScrollView:scrollView andView:self.gridRootView.gridUnderLayerView.containerView];
    [self.gridRootView setNeedsLayout];
    
    [self changeRulerPositions];
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andView:(UIView *)view {
	CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = view.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
	
	return frameToCenter;
}

- (void)changeRulerPositions
{
    self.gridRootView.topRuler.frame = CGRectMake(-self.gridRootView.gridUnderLayerView.scrollView.contentOffset.x, 0.0f,
                                                  self.gridRootView.gridUnderLayerView.scrollView.contentSize.width , kSURulerSize);
    self.gridRootView.sideRuler.frame = CGRectMake(0.0f, -self.gridRootView.gridUnderLayerView.scrollView.contentOffset.y,
                                                   kSURulerSize, self.gridRootView.gridUnderLayerView.scrollView.contentSize.height);
}

#pragma mark - Other stuff
- (void)tapOnCloseButton
{
    [self.delegate tapOnCloseButton];
}


@end
