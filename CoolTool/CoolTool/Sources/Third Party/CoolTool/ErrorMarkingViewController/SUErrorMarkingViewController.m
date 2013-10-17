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
#import "SUShareController.h"
#import "SUConstants.h"
#import "SUMarkColorView.h"

static CGRect const kSUMarkViewFrame = {{50.0f, 50.0f}, {150.0f, 150.0f}};
static CGRect const kSUMarkViewCloseButtonFrame = {{10.0f, 10.0f}, {30.0f, 30.0f}};
static CGFloat const kSUMinValidScale = 0.8f;
static CGFloat const kSUMaxValidScale = 2.0f;
static CGFloat const kSUScaleRestraintStartValue = 1.5f;
static NSString * const kSUShakingAnimationKey = @"shakingAnimation";

@interface SUErrorMarkingViewController () <UIGestureRecognizerDelegate, SUMarkViewDelegate, SUMarkColorViewDelegate>

@property (nonatomic, strong) UIImage *screenshotImage;
@property (nonatomic, strong) SUErrorMarkingView *errorMarkingView;
@property (nonatomic, strong) SUShareController *shareController;

@end

@implementation SUErrorMarkingViewController

- (id)initWithScreenshotImage:(UIImage *)screenshotImage
{
    self = [super init];
	if (self) {
        // Init screenshot image
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
    
    self.shareController = [[SUShareController alloc] initWithToolbar:self.errorMarkingView.errorMarkingToolbar onViewController:self];
    
    // Error marking toolbar actions
    [self.errorMarkingView.errorMarkingToolbar.addMarkingViewButton addTarget:self
                                                           action:@selector(addMarkView)];
    [self.errorMarkingView.errorMarkingToolbar.closeButton addTarget:self
                                                  action:@selector(showPreviousViewController)
                                        forControlEvents:UIControlEventTouchUpInside];
    
    // Error marking view gestures
    [self.errorMarkingView.pinchGesture addTarget:self action:@selector(handlePinch:)];
    [self.errorMarkingView.tapGesture addTarget:self action:@selector(stopShakingAnimation)];
    
    // Mark view toolbar
    [self.errorMarkingView.markViewToolbar.cornerTypeButton addTarget:self
                                                               action:@selector(changeCornerType)];
    [self.errorMarkingView.markViewToolbar.widthSlider addTarget:self
                                         action:@selector(changeBorderWidth:)
                               forControlEvents:UIControlEventValueChanged];
    self.errorMarkingView.markViewToolbar.markColorView.delegate = self;
    
}

- (void)addMarkView
{
    [self stopShakingAnimation];
    [self makeMarkViewToolbarButtonsActive:YES];
    
    for (SUMarkView *subView in [self.errorMarkingView subviews])
    {
        if ([subView isKindOfClass:[SUMarkView class]]) {
            subView.isActive = NO;
        }
    }
    SUMarkView *markView = [[SUMarkView alloc] initWithFrame:kSUMarkViewFrame withView:self.errorMarkingView];
    markView.delegate = self;
    [markView.tapGesture addTarget:self action:@selector(handleTap:)];
    [markView.longPressGesture addTarget:self action:@selector(handleLongPress:)];
    self.errorMarkingView.markViewToolbar.widthSlider.value = markView.layer.borderWidth;
    [self.errorMarkingView addSubview:markView];
}

- (void)showPreviousViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Mark View toolbar
- (void)changeCornerType
{
    for (SUMarkView *subview in [self.errorMarkingView subviews])
    {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            if (subview.isActive) {
                if (subview.layer.cornerRadius == kSUCornerRadius) {
                    subview.layer.cornerRadius = 0;
                } else {
                    subview.layer.cornerRadius = kSUCornerRadius;
                }
            }
        }
    }
}

- (void)changeBorderWidth:(UISlider *)sender
{
    NSInteger discreteValue = roundl([sender value]);
    [sender setValue:(CGFloat)discreteValue];
    
    for (SUMarkView *subview in [self.errorMarkingView subviews])
    {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            if (subview.isActive) {
                subview.borderWidth = discreteValue;
                subview.layer.borderWidth = subview.borderWidth * 2;
            }
        }
    }
}

- (void)colorViewPickedWithColor:(UIColor *)color
{
    for (SUMarkView *subview in [self.errorMarkingView subviews])
    {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            if (subview.isActive) {
                subview.layer.borderColor = color.CGColor;
            }
        }
    }
}

- (void)makeMarkViewToolbarButtonsActive:(BOOL)isActive
{
    self.errorMarkingView.errorMarkingToolbar.showMarkingViewToolbarButton.enabled = isActive;
}

#pragma mark Handle long tap gesture

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    [self makeViewActiveWithRecognizer:recognizer];
    
    for (SUMarkView *subview in [self.errorMarkingView subviews])
    {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            [subview.layer addAnimation:[self shakingViewAnimation] forKey:kSUShakingAnimationKey];
            // Init button
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor blackColor];
            button.frame = kSUMarkViewCloseButtonFrame;
            [button addTarget:self action:@selector(removeMarkView:) forControlEvents:UIControlEventTouchUpInside];
            [subview addSubview:button];
        }
    }
}

- (CAAnimation *)shakingViewAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    animation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-0.05f],
                        [NSNumber numberWithFloat:0.05f],
                        nil];
    animation.duration = 0.1f;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VALF;
    return animation;
}

- (void)removeMarkView:(id)sender
{
    [((UIButton *)sender).superview removeFromSuperview];
    [self makeMarkViewToolbarButtonsActive:NO];
    for (SUMarkView *subview in [self.errorMarkingView subviews])
    {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            [self makeMarkViewToolbarButtonsActive:YES];
        }
    }
    
}

- (void)stopShakingAnimation
{
    for (SUMarkView *subview in [self.errorMarkingView subviews])
    {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            [subview.layer removeAnimationForKey:kSUShakingAnimationKey];
            for (UIButton *button in [subview subviews]) {
                [button removeFromSuperview];
            }
        }
    }
}

#pragma mark Handle tap and pan gestures

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
    
    self.errorMarkingView.markViewToolbar.widthSlider.value = ((SUMarkView *)recognizer.view).borderWidth;
    if (!((SUMarkView *)recognizer.view).isActive) {
        ((SUMarkView *)recognizer.view).isActive = YES;
    }
}

#pragma mark Handle pinch gesture

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

#pragma mark Different delegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
