//
//  SUGridRootView.m
//  CoolTool
//
//  Created by Alex Saenko on 9/25/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridRootView.h"
#import "SUZoomController.h"

static const CGFloat kSUToolBarHeight = 44.0f;
static const CGFloat kSUToolBarWidth = 320.0f;
static const CGFloat kSUStatusBarheight = 20.0f;

@interface SUGridRootView ()

@property (nonatomic, strong) SUZoomController *zoomController;

@end

@implementation SUGridRootView

- (id)initWithScreenshotImage:(UIImage *)screenshotImage
{
	self = [super init];
	if (self) {
        self.backgroundColor = [UIColor clearColor];
        
		// Init underlayer view
        self.gridUnderLayerView = [[SUGridUnderLayerView alloc] initWithScreenshotImage:screenshotImage];
        self.gridUnderLayerView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.gridUnderLayerView];
        
        // Init toolbar
        self.toolbar = [[SUToolbarView alloc] init];
        self.toolbar.hidden = YES;
        [self addSubview:self.toolbar];
        
        // Init tapGesture
        [self.gridUnderLayerView.gridView.tapGesture addTarget:self action:@selector(viewTapped)];
        
        self.zoomController = [[SUZoomController alloc] initWithView:self.gridUnderLayerView];
        
        [self layoutGridViewDependingOnOrientation];
	}
	return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
        
    CGSize sz = [super bounds].size;
        
    CGSize toolbarSize = CGSizeMake(kSUToolBarWidth, kSUToolBarHeight);
    
    self.toolbar.frame = CGRectMake(sz.width / 2 - toolbarSize.width / 2,
                                    sz.height - toolbarSize.height,
                                    toolbarSize.width, toolbarSize.height);
}

- (void)viewTapped
{
    if (self.toolbar.isHidden) {
        self.toolbar.hidden = NO;
    } else {
        self.toolbar.hidden = YES;
    }
}

- (void)layoutGridViewDependingOnOrientation
{
    CGSize sz = [[UIScreen mainScreen] bounds].size;
    
    if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        self.gridUnderLayerView.frame = CGRectMake(0.0f, 0.0f, sz.height, sz.width - kSUStatusBarheight);
    } else {
        self.gridUnderLayerView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height - kSUStatusBarheight);
    }
    
}

@end
