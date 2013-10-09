//
//  SUGridToolbar.h
//  CoolTool
//
//  Created by Alex Saenko on 10/9/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUToolbarView.h"
#import "SUCompositeButton.h"

@interface SUGridToolbar : SUToolbarView

@property (nonatomic, strong) SUCompositeButton *gridDisplayButton;
@property (nonatomic, strong) SUCompositeButton *showPickerButton;
@property (nonatomic, strong) UISlider *slider;

@end
