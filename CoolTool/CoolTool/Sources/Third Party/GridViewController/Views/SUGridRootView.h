//
//  SUGridRootView.h
//  CoolTool
//
//  Created by Alex Saenko on 9/25/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUGridUnderLayerView.h"
#import "SUToolbarView.h"

@interface SUGridRootView : UIView

@property (nonatomic, strong) SUGridUnderLayerView *gridUnderLayerView;
@property (nonatomic, strong) SUToolbarView *toolbar;

- (id)initWithScreenshotImage:(UIImage *)screenshotImage;
- (void)layoutGridViewDependingOnOrientation;

@end
