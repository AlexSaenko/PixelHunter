//
//  SUErrorMarkingViewController.m
//  CoolTool
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUErrorMarkingViewController.h"
#import "SUErrorMarkingView.h"
#import "SUMarkView.h"
#import <QuartzCore/QuartzCore.h>

static const CGRect kSUMarkViewFrame = {{50.0f, 50.0f}, {150.0f, 150.0f}};
static const CGFloat kSUMinValidScale = 0.8f;
static const CGFloat kSUMaxValidScale = 2.0f;
static const CGFloat kSUScaleRestraintStartValue = 1.5f;

@interface SUErrorMarkingViewController () <UIGestureRecognizerDelegate, SUMarkViewDelegate>

@property (nonatomic, strong) UIImage *screenshotImage;
@property (nonatomic, strong) SUErrorMarkingView *errorMarkingView;

@end

@implementation SUErrorMarkingViewController

- (id)initWithScreenshotImage:(UIImage *)screenshotImage
{
    self = [super init];
	if (self) {
		self.screenshotImage = screenshotImage;
	}
    
	return self;
}

- (void)loadView
{
    SUErrorMarkingView *view = [[SUErrorMarkingView alloc] initWithScreenshotImage:self.screenshotImage];
    view.contentMode = UIViewContentModeScaleAspectFit;
    self.view = view;
    self.errorMarkingView = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.errorMarkingView.toolbar.addMarkingViewButton addTarget:self
                                                   action:@selector(addMarkingView)];
    [self.errorMarkingView.pinchGesture addTarget:self action:@selector(handlePinch:)];
}

- (void)addMarkingView
{
    for (SUMarkView *subView in [self.errorMarkingView subviews])
    {
        if ([subView isKindOfClass:[SUMarkView class]]) {
            subView.isActive = NO;
        }
    }
    SUMarkView *markView = [[SUMarkView alloc] initWithFrame:kSUMarkViewFrame withView:self.errorMarkingView];
    markView.delegate = self;
    [markView.tapGesture addTarget:self action:@selector(handleTap:)];
    [self.errorMarkingView addSubview:markView];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [self makeViewActiveWithRecognizer:recognizer];
}

- (void)panGestureActivated:(UIPanGestureRecognizer *)recognizer
{
    [self makeViewActiveWithRecognizer:recognizer];
}

- (void)makeViewActiveWithRecognizer:(UIGestureRecognizer *)recognizer
{
    for (SUMarkView *subview in [self.errorMarkingView subviews])
    {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            subview.isActive = NO;
        }
    }
    if (!((SUMarkView *)recognizer.view).isActive) {
        ((SUMarkView *)recognizer.view).isActive = YES;
    }

}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    for (SUMarkView *subview in [self.errorMarkingView subviews])
    {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            if (subview.isActive) {
                CGFloat oldXScale = sqrt(pow(subview.transform.a, 2) + pow(subview.transform.c, 2));
                CGFloat oldYScale = sqrt(pow(subview.transform.b, 2) + pow(subview.transform.d, 2));
                CGPoint scale = CGPointMake(oldXScale * [recognizer scale], oldYScale * [recognizer scale]);
                
                if ([recognizer state] == UIGestureRecognizerStateBegan ||
                    [recognizer state] == UIGestureRecognizerStateChanged)
                {
                    if ([self isScaleValid:scale.x] &&
                        [self isScaleValid:scale.y])
                    {
                        scale = [self getRestraintedScaleWithScale:scale withView:subview];
                        subview.transform = CGAffineTransformScale(subview.transform, scale.x / oldXScale, scale.y / oldYScale);
                    }
                    
                    [recognizer setScale:1.0];
                }
            }
        }
    }
}

- (BOOL)isScaleValid:(CGFloat)scale
{
    if (scale > kSUMaxValidScale)
    {
        return NO;
    }
    
    if (scale < kSUMinValidScale)
    {
        return NO;
    }
    
    return YES;
}

- (CGPoint)getRestraintedScaleWithScale:(CGPoint)scale withView:(UIView *)view
{
    CGPoint resultScale = scale;
    CGPoint oldScale = CGPointMake(sqrt(pow(view.transform.a, 2) + pow(view.transform.c, 2)), sqrt(pow(view.transform.b, 2) + pow(view.transform.d, 2)));
    
    if (oldScale.x > kSUScaleRestraintStartValue ||
        oldScale.y > kSUScaleRestraintStartValue)
    {
        CGFloat resultXScale = oldScale.x + (scale.x - oldScale.x) * (1 - (scale.x - kSUScaleRestraintStartValue) / (kSUMaxValidScale - kSUScaleRestraintStartValue));
        CGFloat resultYScale = oldScale.y + (scale.y - oldScale.y) * (1 - (scale.y - kSUScaleRestraintStartValue) / (kSUMaxValidScale - kSUScaleRestraintStartValue));
        resultScale = CGPointMake(resultXScale, resultYScale);
    }
    
    return resultScale;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
