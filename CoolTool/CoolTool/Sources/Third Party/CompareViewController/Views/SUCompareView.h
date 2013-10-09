//
//  SUCompareView.h
//  CoolTool
//
//  Created by Alex Saenko on 10/8/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUCompareToolbar.h"

@interface SUCompareView : UIView

@property (nonatomic, strong) SUCompareToolbar *toolbar;
@property (nonatomic, strong) UIImageView *mockupImageView;

- (id)initWithScreenshotImage:(UIImage *)screenshotImage withMockupImage:(UIImage *)mockupImage;

@end
