//
//  SUMarkView.h
//  CoolTool
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SUMarkViewDelegate <NSObject>

- (void)panGestureActivated:(UIPanGestureRecognizer *)recognizer;

@end

@interface SUMarkView : UIView

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) id <SUMarkViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withView:(UIView *)view;

@end
