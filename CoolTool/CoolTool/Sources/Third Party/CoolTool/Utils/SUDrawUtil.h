//
//  SUDrawUtil.h
//  CoolTool
//
//  Created by Alex Saenko on 9/30/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUDrawUtil : NSObject

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);

@end
