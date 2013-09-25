//
//  SUZoomController.m
//  CoolTool
//
//  Created by Alex Saenko on 9/24/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUZoomController.h"

static const CGFloat kSUMaxValidScale = 3.0f;
static const CGFloat kSUMinValidScale = 1.0f;
static const CGFloat kSUScaleRestraintStartValue = 1.0f;

@interface SUZoomController ()

@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UIView *gestureView;

@end

@implementation SUZoomController

- (id)initWithGestureView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.gestureView = view;
        
        //Init pinch zoom gesture
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] init];
        [self.pinchGesture addTarget:self action:@selector(handlePinchGesture:)];
        [self.gestureView addGestureRecognizer:self.pinchGesture];
    }
    return self;
}


- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer
{
//    if (UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
//        
//    }
    CGFloat oldXScale = sqrt(pow(self.gestureView.transform.a, 2) + pow(self.gestureView.transform.c, 2));
    CGFloat oldYScale = sqrt(pow(self.gestureView.transform.b, 2) + pow(self.gestureView.transform.d, 2));
    CGPoint scale = CGPointMake(oldXScale * [recognizer scale], oldYScale * [recognizer scale]);
        
    if ([recognizer state] == UIGestureRecognizerStateBegan ||
        [recognizer state] == UIGestureRecognizerStateChanged) {
        if ([self isScaleValid:scale.x] &&
            [self isScaleValid:scale.y]) {
            scale = [self getRestraintedScaleForScale:scale];
            self.gestureView.transform = CGAffineTransformScale(self.gestureView.transform, scale.x / oldXScale, scale.y / oldYScale);
        }
        
        [recognizer setScale:1.0];
    }
//    [self.gestureView setNeedsDisplay];
}
- (BOOL)isScaleValid:(CGFloat)scale
{
    if (scale > kSUMaxValidScale) {
        return NO;
    }
    
    if (scale < kSUMinValidScale) {
        return NO;
    }
    
    return YES;
}

- (CGFloat)getValidScaleForScale:(CGFloat)scale
{
    if (scale < kSUMinValidScale) {
        scale = kSUMinValidScale;
    }
    
    if (scale > kSUMaxValidScale) {
        scale = kSUMaxValidScale;
    }
    
    return scale;
}

- (CGPoint)getRestraintedScaleForScale:(CGPoint)scale
{
    CGPoint resultScale = scale;
    CGPoint oldScale = CGPointMake(sqrt(pow(self.gestureView.transform.a, 2) + pow(self.gestureView.transform.c, 2)),
                                   sqrt(pow(self.gestureView.transform.b, 2) + pow(self.gestureView.transform.d, 2)));
    
    if (oldScale.x > kSUScaleRestraintStartValue ||
        oldScale.y > kSUScaleRestraintStartValue) {
        CGFloat resultXScale = oldScale.x + (scale.x - oldScale.x) * (1 - (scale.x - kSUScaleRestraintStartValue) / (kSUMaxValidScale - kSUScaleRestraintStartValue));
        CGFloat resultYScale = oldScale.y + (scale.y - oldScale.y) * (1 - (scale.y - kSUScaleRestraintStartValue) / (kSUMaxValidScale - kSUScaleRestraintStartValue));
        resultScale = CGPointMake(resultXScale, resultYScale);
    }
    
    return resultScale;
}

@end
