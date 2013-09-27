//
//  SUMotionController.m
//  CoolTool
//
//  Created by Alex Saenko on 9/26/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUMotionController.h"

static const CGFloat kSUMotionRestraintDegree = 0.33f;
static const CGFloat kSUViewReturnAnimationDuration = 0.35f;

@interface SUMotionController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIView *panView;

@end

@implementation SUMotionController

- (id)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.panView = view;
        
        //Init pan zoom gesture
        self.panGesture = [[UIPanGestureRecognizer alloc] init];
        [self.panGesture addTarget:self action:@selector(handlePan:)];
        [self.panGesture setDelegate:self];
        [self.panGesture setMaximumNumberOfTouches:1];
        
        [self.panView addGestureRecognizer:self.panGesture];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
//    CGPoint translation = [recognizer translationInView:self.panView];
//    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
//                                         recognizer.view.center.y + translation.y);
//    [recognizer setTranslation:CGPointMake(0, 0) inView:self.panView];
//    if (recognizer.state == UIGestureRecognizerStateEnded) {
//        
//        CGPoint velocity = [recognizer velocityInView:self.panView];
//        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
//        CGFloat slideMult = magnitude / 200;
//        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
//        
//        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
//        CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),
//                                         recognizer.view.center.y + (velocity.y * slideFactor));
//        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.panView.bounds.size.width);
//        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.panView.bounds.size.height);
//        
//        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            recognizer.view.center = finalPoint;
//        } completion:nil];
//        
//    }
    
    CGPoint translation = [recognizer translationInView:self.panView];
    CGPoint newOrigin = CGPointMake(self.panView.frame.origin.x + translation.x, self.panView.frame.origin.y + translation.y);
    
    if (![self isCalendarOriginValid:newOrigin])
    {
        translation = [self getRestraintedTranslationFor:translation
                                     andTranslatedOrigin:newOrigin];
        newOrigin = CGPointMake(self.panView.frame.origin.x + translation.x, self.panView.frame.origin.y + translation.y);
    }
    
    CGRect newFrame = CGRectMake(newOrigin.x, newOrigin.y, self.panView.frame.size.width, self.panView.frame.size.height);
    
    [self.panView setFrame:newFrame];
    [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
        
    if ((recognizer.state == UIGestureRecognizerStateEnded) ||
        (recognizer.state == UIGestureRecognizerStateCancelled))
    {
        [self correctCalendarArea];
    }
}

- (void)correctCalendarArea
{
    if (![self isCalendarOriginValid:self.panView.frame.origin])
    {
        [self returnViewToValidArea];
    }
}

- (CGPoint)getRestraintedTranslationFor:(CGPoint)translation
                    andTranslatedOrigin:(CGPoint)translatedOrigin
{
    CGRect frame = CGRectMake(translatedOrigin.x, translatedOrigin.y, self.panView.frame.size.width, self.panView.frame.size.height) ;
    CGFloat leftBorder = 0;
    CGFloat rightBorder = self.panView.superview.frame.size.width;
    CGFloat topBorder = 0;
    CGFloat bottomBorder = self.panView.superview.frame.size.height;
    
    CGFloat outOfMainFrameX = MAX((leftBorder - frame.origin.x), (frame.origin.x + frame.size.width - rightBorder));
    CGFloat outOfMainFrameY = MAX((topBorder - frame.origin.y), (frame.origin.y + frame.size.height - bottomBorder));
    
    CGFloat restraintCoefficientX;
    if (outOfMainFrameX > 0)
    {
        restraintCoefficientX = 1 / (powf(outOfMainFrameX, kSUMotionRestraintDegree));
    }
    else
    {
        restraintCoefficientX = 1;
    }
    
    CGFloat restraintCoefficientY;
    if (outOfMainFrameY > 0)
    {
        restraintCoefficientY = 1 / (powf(outOfMainFrameY, kSUMotionRestraintDegree));
    }
    else
    {
        restraintCoefficientY = 1;
    }
    
    return CGPointMake(translation.x * restraintCoefficientX, translation.y * restraintCoefficientY);
}

- (BOOL)isCalendarOriginValid:(CGPoint)origin
{
    if ((origin.x < 0) || (origin.y < 0))
    {
        return NO;
    }
    
    if ((origin.x + self.panView.frame.size.width) > self.panView.superview.frame.size.width)
    {
        return NO;
    }
    
    if ((origin.y + self.panView.frame.size.height) > self.panView.superview.frame.size.height)
    {
        return NO;
    }
    
    return YES;
}

- (void)returnViewToValidArea
{
    CGPoint validOrigin = [self getValidOriginForOrigin:self.panView.frame.origin];
    CGRect validFrame = CGRectMake(validOrigin.x, validOrigin.y, self.panView.frame.size.width, self.panView.frame.size.height);
    [UIView animateWithDuration:kSUViewReturnAnimationDuration
                          delay:0
                        options:0
                     animations:^
     {
         [self.panView setFrame:validFrame];
     }
                     completion:^(BOOL animated)
     {
         
     }];
}

- (CGPoint)getValidOriginForOrigin:(CGPoint)origin
{
    NSUInteger validX, validY;
    if (origin.x < 0)
    {
        validX = 0;
    }
    else if ((origin.x + self.panView.frame.size.width) > self.panView.superview.frame.size.width)
    {
        validX = self.panView.superview.frame.size.width - self.panView.frame.size.width;
    }
    else
    {
        validX = origin.x;
    }
    
    if (origin.y < 0)
    {
        validY = 0;
    }
    else if ((origin.y + self.panView.frame.size.height) > self.panView.superview.frame.size.height)
    {
        validY = self.panView.superview.frame.size.height - self.panView.frame.size.height;
    }
    else
    {
        validY = origin.y;
    }
    
    return CGPointMake(validX, validY);
}


@end
