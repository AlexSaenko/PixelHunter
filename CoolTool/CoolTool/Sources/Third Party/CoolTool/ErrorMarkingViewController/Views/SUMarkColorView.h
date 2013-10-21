//
//  SUMarkColorView.h
//  CoolTool
//
//  Created by Alex Saenko on 10/17/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SUMarkColorViewDelegate <NSObject>

- (void)colorViewPickedWithColor:(UIColor *)color;

@end


@interface SUMarkColorView : UIView

@property (nonatomic, assign) id <SUMarkColorViewDelegate> delegate;

@end
