//
//  SUZoomController.h
//  CoolTool
//
//  Created by Alex Saenko on 9/24/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUZoomController : NSObject

@property (nonatomic, assign) CGPoint pinchScale;
@property (nonatomic, assign) CGPoint viewCenterPoint;

- (id)initWithView:(UIView *)view;

@end
