//
//  SUToolbarView.h
//  CoolTool
//
//  Created by Alex Saenko on 9/20/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUCompositeButton.h"

@interface SUToolbarView : UIView

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) SUCompositeButton *gridDisplayButton;

@end
