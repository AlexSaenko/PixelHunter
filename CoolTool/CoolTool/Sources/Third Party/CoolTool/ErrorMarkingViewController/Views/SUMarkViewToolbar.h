//
//  SUMarkViewToolbar.h
//  CoolTool
//
//  Created by Alex Saenko on 10/15/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUCompositeButton.h"
#import "SUMarkColorView.h"

@interface SUMarkViewToolbar : UIView

@property (nonatomic, strong) SUCompositeButton *cornerTypeButton;
@property (nonatomic, strong) SUCompositeButton *borderWidthSliderButton;
@property (nonatomic, strong) SUCompositeButton *borderColorPickerButton;
@property (nonatomic, strong) SUMarkColorView *markColorView;
@property (nonatomic, strong) UISlider *widthSlider;

@end
