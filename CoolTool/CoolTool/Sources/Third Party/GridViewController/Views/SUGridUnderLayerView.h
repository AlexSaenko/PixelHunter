//
//  SUUnderLayerView.h
//  CoolTool
//
//  Created by Alex Saenko on 9/18/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUGridView.h"

@interface SUGridUnderLayerView : UIView

@property (nonatomic, strong) SUGridView *gridView;

- (id)initWithScreenshotImage:(UIImage *)image;

@end
