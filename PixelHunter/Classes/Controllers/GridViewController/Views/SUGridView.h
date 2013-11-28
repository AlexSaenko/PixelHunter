//
//  SUGridView.h
//  PixelHunter
//
//  Created by Alex Saenko on 9/18/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SUGridView : UIView

@property (nonatomic, assign) NSInteger startVerticalPoint;
@property (nonatomic, assign) NSInteger startHorizontalPoint;

- (id)initWithSmallGrid:(BOOL)isSmallGrid;

@end
