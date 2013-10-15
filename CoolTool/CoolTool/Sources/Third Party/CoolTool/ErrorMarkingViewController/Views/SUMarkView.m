//
//  SUMarkView.m
//  CoolTool
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUMarkView.h"

@interface SUMarkView ()

@property (nonatomic, strong) UIView *gestureView;
@property (nonatomic, assign) CGFloat borderWidth;

@end

@implementation SUMarkView

- (id)initWithFrame:(CGRect)frame withView:(UIView *)view
{
    self = [super initWithFrame:frame];
    if (self) {
        self.gestureView = view;
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.borderWidth = 1.0f;
        self.layer.borderWidth = self.borderWidth;
        self.layer.cornerRadius = 10.0f;
        self.isActive = YES;
        
        self.tapGesture = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.tapGesture];
        self.panGesture = [[UIPanGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.panGesture];
        [self.panGesture addTarget:self action:@selector(handlePan:)];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    [self.delegate panGestureActivated:recognizer];
    CGPoint translation = [recognizer translationInView:self.gestureView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.gestureView];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x,
                                         recognizer.view.center.y);
        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.gestureView.bounds.size.width);
        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.gestureView.bounds.size.height);
    }
}

- (void)setIsActive:(BOOL)isActive
{
    if (isActive) {
        self.layer.borderWidth = self.borderWidth * 2;
    } else {
        self.layer.borderWidth = self.borderWidth;
    }
    _isActive = isActive;
}

@end
