//
//  SUCompareViewController.h
//  CoolTool
//
//  Created by Alex Saenko on 10/8/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SUCompareViewControllerDelegate <NSObject>

- (void)tapOnCloseButton;

@end

@interface SUCompareViewController : UIViewController

@property (nonatomic, assign) id <SUCompareViewControllerDelegate> delegate;

- (id)initWithScreenshotImage:(UIImage *)screenshotImage withMockupImage:(UIImage *)mockupImage;

@end
