//
//  SUErrorMarkingView.h
//  CoolTool
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUErrorMarkingToolbar.h"

@interface SUErrorMarkingView : UIView

@property (nonatomic, strong) SUErrorMarkingToolbar *toolbar;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;

- (id)initWithScreenshotImage:(UIImage *)screenshotImage;

@end
