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
#import "SUTextMarkView.h"

static CGRect const kSUMarkViewFrame = {{50.0f, 50.0f}, {150.0f, 150.0f}};
static CGRect const kSUMarkViewRemoveButtonFrame = {{10.0f, 10.0f}, {30.0f, 30.0f}};
static CGFloat const kSUMinValidScale = 0.8f;
static CGFloat const kSUMaxValidScale = 2.0f;
static CGFloat const kSUScaleRestraintStartValue = 1.5f;
static NSString * const kSUShakingAnimationKey = @"shakingAnimation";
static CGFloat const kSUMinimumViewSideSize = 10.0f;

@interface SUErrorMarkingViewController () <UIGestureRecognizerDelegate, SUMarkViewDelegate, SUMarkColorViewDelegate>

@property (nonatomic, strong) UIImage *screenshotImage;
@property (nonatomic, strong) SUErrorMarkingView *errorMarkingView;
@property (nonatomic, strong) SUShareController *shareController;
@property (nonatomic, assign) CGFloat horizontalScale;
@property (nonatomic, assign) CGFloat verticalScale;
@property (nonatomic, assign) CGRect tempTextMarkViewRect;
@property (nonatomic, readwrite) BOOL isKeyboardShown;

@end


@implementation SUErrorMarkingViewController

- (id)initWithScreenshotImage:(UIImage *)screenshotImage
{
    self = [super init];
	if (self) {
        // Init screenshot image
		self.screenshotImage = screenshotImage;
        
        // Subscribe for keyboard appearance
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];

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
    
    // Init share controller
    self.shareController = [[SUShareController alloc] initWithToolbar:self.errorMarkingView.errorMarkingToolbar
                                                     onViewController:self];
    
    // Error marking toolbar actions
    [self.errorMarkingView.errorMarkingToolbar.addMarkingViewButton addTarget:self
                                                           action:@selector(addMarkView)];
    [self.errorMarkingView.errorMarkingToolbar.addTextMarkingViewButton addTarget:self
                                                                       action:@selector(addTextMarkView)];
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

- (void)addMarkViewWithText:(BOOL)withText
{
    [self stopShakingAnimation];
    [self makeMarkViewToolbarButtonsActive:YES];
    
    for (SUMarkView *subView in [self.errorMarkingView subviews]) {
        if ([subView isKindOfClass:[SUMarkView class]]) {
            subView.isActive = NO;
        }
    }
    
    SUMarkView *markView;
    if (withText) {
        markView = [[SUTextMarkView alloc] initWithFrame:kSUMarkViewFrame withView:self.errorMarkingView];
    } else {
        markView = [[SUMarkView alloc] initWithFrame:kSUMarkViewFrame withView:self.errorMarkingView];
    }
    markView.delegate = self;
    [markView.tapGesture addTarget:self action:@selector(handleTap:)];
    [markView.longPressGesture addTarget:self action:@selector(handleLongPress:)];
    self.errorMarkingView.markViewToolbar.widthSlider.value = markView.layer.borderWidth;
    [self.errorMarkingView insertSubview:markView belowSubview:self.errorMarkingView.errorMarkingToolbar];
}

- (void)addMarkView
{
    [self addMarkViewWithText:NO];
}

- (void)addTextMarkView
{
    [self addMarkViewWithText:YES];
}

- (void)showPreviousViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Mark View toolbar
- (void)changeCornerType
{
    for (SUMarkView *subview in [self.errorMarkingView subviews]) {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            if (subview.isActive) {
                if (subview.layer.cornerRadius == kSUCornerRadius) {
                    subview.layer.cornerRadius = 0.0f;
                    if ([subview isKindOfClass:[SUTextMarkView class]]) {
                        ((SUTextMarkView *)subview).commentTextView.layer.cornerRadius = 0.0f;
                    }
                } else {
                    subview.layer.cornerRadius = kSUCornerRadius;
                    if ([subview isKindOfClass:[SUTextMarkView class]]) {
                        ((SUTextMarkView *)subview).commentTextView.layer.cornerRadius = kSUCornerRadius;
                    }
                }
            }
        }
    }
}

- (void)changeBorderWidth:(UISlider *)sender
{
    for (SUMarkView *subview in [self.errorMarkingView subviews]) {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            if (subview.isActive) {
                subview.layer.borderWidth = [sender value];
            }
        }
    }
}

- (void)colorViewPickedWithColor:(UIColor *)color
{
    for (SUMarkView *subview in [self.errorMarkingView subviews]) {
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

#pragma mark - Handle long tap gesture

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    [self makeViewActiveWithRecognizer:recognizer];
    
    for (SUMarkView *subview in [self.errorMarkingView subviews]) {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            [subview.layer addAnimation:[self shakingViewAnimation] forKey:kSUShakingAnimationKey];
            
            // Init remove mark view button
            UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            removeButton.backgroundColor = [UIColor blackColor];
            removeButton.frame = kSUMarkViewRemoveButtonFrame;
            [removeButton addTarget:self action:@selector(removeMarkView:) forControlEvents:UIControlEventTouchUpInside];
            [subview addSubview:removeButton];
        }
    }
}

- (void)removeMarkView:(id)sender
{
    [((UIButton *)sender).superview removeFromSuperview];
    [self makeMarkViewToolbarButtonsActive:NO];
    for (SUMarkView *subview in [self.errorMarkingView subviews]) {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            [self makeMarkViewToolbarButtonsActive:YES];
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

- (void)stopShakingAnimation
{
    for (SUMarkView *subview in [self.errorMarkingView subviews]) {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            [subview.layer removeAnimationForKey:kSUShakingAnimationKey];
            for (UIButton *button in [subview subviews]) {
                if ([button isKindOfClass:[UIButton class]]) {
                    [button removeFromSuperview];
                }
            }
        }
    }
}

#pragma mark - Handle tap and pan gestures

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [self makeViewActiveWithRecognizer:recognizer];
    
    for (SUTextMarkView *subview in [self.errorMarkingView subviews]) {
        if ([subview isKindOfClass:[SUTextMarkView class]]) {
            if (subview.isActive) {
                subview.commentTextView.userInteractionEnabled = YES;
                [subview.commentTextView becomeFirstResponder];
            } else {
                subview.commentTextView.userInteractionEnabled = NO;
            }
        }
    }
}

- (void)panGestureActivated:(UIPanGestureRecognizer *)recognizer
{
    for (SUTextMarkView *subview in [self.errorMarkingView subviews]) {
        if ([subview isKindOfClass:[SUTextMarkView class]]) {
            if (subview.isActive) {
                if (!CGRectIsEmpty(self.tempTextMarkViewRect)) {
                    self.tempTextMarkViewRect = subview.frame;
                }
            }
        }
    }
    [self makeViewActiveWithRecognizer:recognizer];
}

- (void)makeViewActiveWithRecognizer:(UIGestureRecognizer *)recognizer
{
    for (SUMarkView *subview in [self.errorMarkingView subviews]) {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            subview.isActive = NO;
        }
    }
    
    self.errorMarkingView.markViewToolbar.widthSlider.value = ((SUMarkView *)recognizer.view).layer.borderWidth;
    
    if (!((SUMarkView *)recognizer.view).isActive) {
        ((SUMarkView *)recognizer.view).isActive = YES;
    }
}

#pragma mark - Handle pinch gesture

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    for (SUMarkView *subview in [self.errorMarkingView subviews]) {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            if (subview.isActive) {
                if ([recognizer numberOfTouches] == 2) {
                    CGFloat x = [recognizer locationInView:subview].x - [recognizer locationOfTouch:1 inView:subview].x;
                    if (x < 0) {
                        x *= -1;
                    }
                    CGFloat y = [recognizer locationInView:subview].y - [recognizer locationOfTouch:1 inView:subview].y;
                    if (y < 0) {
                        y *= -1;
                    }
                    
                    if (recognizer.state == UIGestureRecognizerStateBegan) {
                        self.horizontalScale = subview.bounds.size.width - x * 2;
                        self.verticalScale = subview.bounds.size.height - y * 2;
                    }
                        
                    CGFloat width = x * 2 + self.horizontalScale;
                    if (width < kSUMinimumViewSideSize) {
                        width = kSUMinimumViewSideSize;
                    }
                    CGFloat height = y * 2 + self.verticalScale;
                    if (height < kSUMinimumViewSideSize) {
                        height = kSUMinimumViewSideSize;
                    }
                    subview.bounds = CGRectMake(subview.bounds.origin.x , subview.bounds.origin.y , width, height);
                    [recognizer setScale:1.0f];
                }
            }
        }
    }
}

#pragma mark - Different delegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)keyboardWillShow:(id)sender
{
    NSDictionary *userInfo = [sender userInfo];
    
    CGRect keyboardRect = [[userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    CGFloat keyboardAnimationTime = [[userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];

    for (SUTextMarkView *subview in [self.errorMarkingView subviews]) {
        if ([subview isKindOfClass:[SUTextMarkView class]]) {
            if (subview.isActive) {
                self.tempTextMarkViewRect = subview.frame;
                if (subview.frame.origin.y + subview.frame.size.height > self.view.frame.size.height - keyboardRect.size.height) {
                    CGRect tempRect = subview.frame;
                    tempRect.origin.y = self.view.frame.size.height - keyboardRect.size.height - subview.frame.size.height - 20.0f;
                    [UIView animateWithDuration:keyboardAnimationTime animations:^{
                        subview.frame = tempRect;
                    }];
                }
                
            }
        }
    }
}

- (void)keyboardWillHide:(id)sender
{
    NSDictionary *userInfo = [sender userInfo];
    
    CGFloat keyboardAnimationTime = [[userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];

    for (SUTextMarkView *subview in [self.errorMarkingView subviews]) {
        if ([subview isKindOfClass:[SUTextMarkView class]]) {
            if (subview.isActive) {
                if (!CGRectIsEmpty(self.tempTextMarkViewRect)) {
                    [UIView animateWithDuration:keyboardAnimationTime animations:^{
                        subview.frame = self.tempTextMarkViewRect;
                    }];
                }
            }
        }
    }

}

@end
