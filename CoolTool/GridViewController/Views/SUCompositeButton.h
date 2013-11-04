//
//  SUCompositeButton.h
//  CoolTool
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    SUCompositeButtonStateNormal,
    SUCompositeButtonStateActivated,
}SUCompositeButtonState;


@interface SUCompositeButton : UIView

- (id)initWithImageNameNormal:(NSString *)imageNameNormal
             imageNamePressed:(NSString *)imageNamePressed
           imageNameActivated:(NSString *)imageNameActivated;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) SUCompositeButtonState state;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) BOOL enabled;

- (void)addTarget:(id)target action:(SEL)action;

@end
