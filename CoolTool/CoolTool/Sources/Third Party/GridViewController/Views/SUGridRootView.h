//
//  SUGridRootView.h
//  CoolTool
//
//  Created by Alex Saenko on 9/25/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUGridUnderLayerView.h"
#import "SUGridToolbar.h"
#import "SUGridRulerView.h"
#import "SUSmallGridView.h"

@interface SUGridRootView : UIView

@property (nonatomic, strong) SUGridUnderLayerView *gridUnderLayerView;
@property (nonatomic, strong) SUGridToolbar *toolbar;
@property (nonatomic, strong) SUGridRulerView *topRuler;
@property (nonatomic, strong) SUGridRulerView *sideRuler;
@property (nonatomic, strong) SUSmallGridView *smallGridView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;


- (id)initWithFrame:(CGRect)rect withScreenshotImage:(UIImage *)screenshotImage;
- (void)layoutViewsDependingOnOrientation;

@end
