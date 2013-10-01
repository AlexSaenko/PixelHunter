//
//  SUGridRootView.m
//  CoolTool
//
//  Created by Alex Saenko on 9/25/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridRootView.h"
#import "SUMotionController.h"
#import "SUConstants.h"
static const CGFloat kSUToolBarHeight = 44.0f;
static const CGFloat kSUToolBarWidth = 320.0f;

@interface SUGridRootView ()

@property (nonatomic, strong) SUMotionController *motionController;

@end

@implementation SUGridRootView

- (id)initWithFrame:(CGRect)rect withScreenshotImage:(UIImage *)screenshotImage
{
	self = [super initWithFrame:rect];
	if (self) {
        self.backgroundColor = [UIColor clearColor];
        
		// Init underlayer view
        self.gridUnderLayerView = [[SUGridUnderLayerView alloc] initWithFrame:rect withScreenshotImage:screenshotImage];
        self.gridUnderLayerView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.gridUnderLayerView];
        
        // Init toolbar
        self.toolbar = [[SUToolbarView alloc] init];
        self.toolbar.hidden = YES;
        [self addSubview:self.toolbar];
        
        // Init tapGesture
        [self.gridUnderLayerView.gridView.tapGesture addTarget:self action:@selector(viewTapped)];
                
        // Init rulers
        self.topRuler = [[SUGridRulerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, rect.size.width, kSURulerSize) horizontal:YES];
        [self addSubview:self.topRuler];
        
        self.sideRuler = [[SUGridRulerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kSURulerSize, rect.size.height) horizontal:NO];
        [self addSubview:self.sideRuler];
        
        // Layout
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
    
    self.topRuler.scale = self.gridUnderLayerView.scrollView.zoomScale;
    self.sideRuler.scale = self.gridUnderLayerView.scrollView.zoomScale;
    [self.topRuler setNeedsDisplay];
    [self.sideRuler setNeedsDisplay];
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
        self.gridUnderLayerView.frame = CGRectMake(0.0f, 0.0f, sz.height, sz.width - kSUStatusBarHeight);
    } else {
        self.gridUnderLayerView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height - kSUStatusBarHeight);
    }
    
}

@end
