//
//  SUColorView.h
//  CoolTool
//
//  Created by Alex Saenko on 10/17/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SUColorView : UIView

@property (nonatomic, strong) UIView *smallColorView;
@property (nonatomic, strong) UIButton *colorViewButton;

- (id)initWithColor:(UIColor *)color;

@end
